; chrome://dino, adapted to Assembly
; Built for a console with 30 rows and 120 columns

INCLUDE Irvine32.inc

TARGET_ROWS = 30
TARGET_COLS = 120

.data

consoleSizeTargetName  BYTE "Target",0

printCoordinatePrefix BYTE ": (",0 ; Text printed after the label and before X
printCoordinateSep    BYTE ", ",0  ; Text printed between X and Y
printCoordinateSuffix BYTE ")",0   ; Text printed after Y

.code

; Determines if the current console size equals the 
; target dimensions.
; Returns: BL = 1 if size matches, 0 otherwise
VerifyConsoleSize PROC USES eax edx
	call GetMaxXY
	cmp  al, TARGET_ROWS
	jne  Otherwise
	cmp  dl, TARGET_COLS
	jne  Otherwise

	Match:
		mov bl,1
		jmp Return
	Otherwise:
		mov bl,0
	Return:
		ret
VerifyConsoleSize ENDP

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

main PROC
	; Test PrintCoordinate
	INVOKE PrintCoordinate, ADDR consoleSizeTargetName, TARGET_ROWS, TARGET_COLS

	exit
main ENDP
END main