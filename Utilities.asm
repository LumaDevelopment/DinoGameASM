; Utilities to be leveraged by the 
; rest of the program.

INCLUDE DinoGame.inc

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
