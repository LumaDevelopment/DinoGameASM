; Utilities to be leveraged by the 
; rest of the program.

INCLUDE DinoGame.inc

.data

printCoordinatePrefix BYTE ": (",0 ; Text printed after the label and before X
printCoordinateSep    BYTE ", ",0  ; Text printed between X and Y
printCoordinateSuffix BYTE ")",0   ; Text printed after Y

.code

; Given the label for a coordinate, the X value, 
; and the Y value, prints the coordinate, ending 
; with a new line.
PrintCoordinate PROC USES eax edx,
	coordLabel:PTR BYTE, ; Pointer to the null-terminated string that contains the name of the coordinate
	X:DWORD,             ; The x-coordinate (unsigned)
	Y:DWORD              ; The y-coordinate (unsigned)

	mov  edx, coordLabel
	call WriteString
	mov  edx, OFFSET printCoordinatePrefix
	call WriteString
	mov  eax, X
	call WriteDec
	mov  edx, OFFSET printCoordinateSep
	call WriteString
	mov  eax, Y
	call WriteDec
	mov  edx, OFFSET printCoordinateSuffix
	call WriteString
	call Crlf

	ret
PrintCoordinate ENDP

; Given a pointer to a string and a number of characters,
; print that number of characters from the string.
; THIS PROCEDURE DOES NOT CHECK FOR STRING LENGTH
WriteCharsFromString PROC USES eax ebx ecx,
	string:PTR BYTE, ; Pointer to a string
	len:DWORD        ; Unsigned number of characters to print

	mov ebx, string
	mov ecx, len

	PrintChar:
		mov  al, BYTE PTR [ebx]
		call WriteChar
		inc  ebx
		loop PrintChar

	ret
WriteCharsFromString ENDP

END
