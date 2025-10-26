; chrome://dino, adapted to Assembly
; Built for a console with 30 rows and 120 columns

INCLUDE Irvine32.inc

TARGET_ROWS = 30
TARGET_COLS = 120

.data

consoleSizeDNMMsg      BYTE "Console size (Rows, Col) does not match target!",0
consoleSizeTargetName  BYTE "Target",0
consoleSizeActualName  BYTE "Actual",0
consoleSizePromptMsg   BYTE "Please resize the console window and press any key to continue!",0

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

; Holds the user until they resize the console 
; to the target size.
ConsoleSizePrompt PROC USES eax ebx edx
	CheckConsoleSize:
		call VerifyConsoleSize
		cmp  bl, 1
		je   CorrectConsoleSize ; Console size is correct

		; Notify user that console size does not match
		mov  edx, OFFSET consoleSizeDNMMsg
		call WriteString
		call Crlf

		; Print target console size
		INVOKE PrintCoordinate, ADDR consoleSizeTargetName, TARGET_ROWS, TARGET_COLS

		; Move rows and cols to EAX and EBX
		; so INVOKE does not have to widen them
		Call  GetMaxXY
		movzx eax, al
		movzx ebx, dl

		; Print actual console size
		INVOKE PrintCoordinate, ADDR consoleSizeActualName, eax, ebx

		; Prompt the user to resize the console
		mov  edx, OFFSET consoleSizePromptMsg
		call WriteString
		call Crlf
		call Crlf

		; Wait for user to press a key, then try again
		call ReadChar
		jmp CheckConsoleSize

	CorrectConsoleSize:
		call Clrscr ; In case any prompts were put on the screen
		ret
ConsoleSizePrompt ENDP

main PROC
	call ConsoleSizePrompt

	exit
main ENDP
END main