; Utilities to be leveraged by the 
; rest of the program.

INCLUDE DinoGame.inc

.data

linesInSprite BYTE ?

.code

; Given the address of a null-terminated string, 
; puts the number of occurences of "n" in the 
; string + 1 in `linesInSprite`.
CalculateSpriteHeight PROC USES eax ecx esi,
     spriteAddr:PTR BYTE

     ; Initialize registers
     mov esi,spriteAddr
     mov ecx,0

     CountLoop:
          mov al,[esi]
          cmp al,0
          je DoneCounting ; Have reached null terminator?

          cmp al,'n'
          jne SkipIncrement ; Is or is not new line?

          inc ecx ; New line!

     SkipIncrement:
          inc esi
          jmp CountLoop

     DoneCounting:
          inc ecx ; Add line for null terminator
          mov linesInSprite, cl ; move lower byte of ECX into memory
          ret
CalculateSpriteHeight ENDP

; Given two values obtained with `GetTickCount`, 
; calculates the distance between them, accounting 
; for the reset to 0 when the max value is reached.
; Returns in EAX
CalculateTickDelta PROC,
	startTime:DWORD,
	endTime:DWORD

	mov eax,startTime
	cmp eax,endTime

	; If startTime > endTime, then tick counter reset
	; to 0 while the user was playing
	ja OverflowCalc

	; startTime should not equal end time, but just
	; in case
	je EdgeCase

	RegularCalc:
		; Calculate difference between start and end time
		mov eax,endTime
		sub eax,startTime
		jmp EndOfProcedure
	OverflowCalc:
		; Get distance between start time and max
		mov eax,0FFFFFFFFh
		sub eax,startTime

		; Add end time to get total elapsed time
		add eax,endTime

		jmp EndOfProcedure
	EdgeCase:
		mov eax,0
	EndOfProcedure:
		ret
CalculateTickDelta ENDP

; Draw the sprite at the given address, with the
; given height, to the screen at the given position.
DrawSprite PROC USES eax ebx ecx edx esi,
	spriteAddr:PTR BYTE,
	spriteBaseX:BYTE,
	spriteBaseY:BYTE,
     startingCol:DWORD,
     endingCol:DWORD,

     ; TODO ADD START COLUMN AND END COLUMN

     ; Find sprite height
     INVOKE CalculateSpriteHeight, spriteAddr

	; Keep track of rows using EAX, columns
     ; using EBX, and raw character index
     ; using esi
     mov eax,0
     mov ebx,0
     mov esi,0

     ; Loop through every pixel of the sprite,
     ; not drawing anything on spaces,
     ; dropping down to next row on 'n'
     ; and terminating on 0

     NewPixel:
          mov edx, [spriteAddr]
          mov dl, [edx + esi]

          ; On space, skip draw
          cmp dl,' '
          je IncrementColumn

          ; On 'n', increment line
          cmp dl,'n'
          je NewLine

          ; On 0, end draw
          cmp dl,0
          je EndOfProcedure

          ; Finally, if ebx < startingCol or 
          ; ebx > endingCol then skip draw
          cmp ebx,startingCol
          jb IncrementColumn
          cmp ebx,endingCol
          ja IncrementColumn

          ; Otherwise, draw the pixel

     DrawPixel:
          ; Use high byte of DX for row index
          mov dh,al
          add dh,TARGET_ROWS
          sub dh,spriteBaseY
          sub dh,linesInSprite

          ; Use ECX for column index
          mov cl,bl
          sub cl,BYTE PTR startingCol ; Adjust for skipped columns
          add cl,spriteBaseX

          ; Save ESI and use it for character address
          push esi
          add esi,spriteAddr

          ; Save EAX, because it gets modified by the INVOKE
          push eax

          INVOKE SetPixelInScreen, dh, cl, esi

          ; Restore registers
          pop eax
          pop esi

     IncrementColumn:
          inc ebx
          jmp NextPixel

     NewLine:
          inc eax
          mov ebx,0
          jmp NextPixel

     NextPixel:
          inc esi
          jmp NewPixel

     EndOfProcedure:
          ret
DrawSprite ENDP

; Given the label for a coordinate, the X value, 
; and the Y value, prints the coordinate, ending 
; with a new line.
PrintCoordinate PROC USES eax edx,
	coordLabel:PTR BYTE, ; Pointer to the null-terminated string that contains the name of the coordinate
	X:DWORD,             ; The x-coordinate (unsigned)
	Y:DWORD              ; The y-coordinate (unsigned)

	mov  edx, coordLabel
	call WriteString
	mWrite <": (">
	mov  eax, X
	call WriteDec
	mWrite <", ">
	mov  eax, Y
	call WriteDec
	mWriteLn <")">

	ret
PrintCoordinate ENDP

END
