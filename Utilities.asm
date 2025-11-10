; Utilities to be leveraged by the 
; rest of the program.

INCLUDE DinoGame.inc

.code

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
