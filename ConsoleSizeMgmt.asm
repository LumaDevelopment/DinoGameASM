; Tools to ensure the console size is correct

INCLUDE DinoGame.inc

.data

consoleSizeTargetName  BYTE "Target",0
consoleSizeActualName  BYTE "Actual",0

.code

; Determines if the current console size equals the 
; target dimensions.
; Returns: BL = 1 if size matches, 0 otherwise
VerifyConsoleSize PROC USES eax edx,
	targetRows:BYTE, ; The target number of rows on the screen
	targetCols:BYTE ; The target number of columns on the screen

	call GetMaxXY
	cmp  al, targetRows
	jne  Otherwise
	cmp  dl, targetCols
	jne  Otherwise

	Match:
		mov bl,1
		jmp Return
	Otherwise:
		mov bl,0
	Return:
		ret
VerifyConsoleSize ENDP

; Holds the user until they resize the console 
; to the target size.
ConsoleSizePrompt PROC USES eax ebx edx,
	targetRows:BYTE, ; The target number of rows on the screen
	targetCols:BYTE ; The target number of columns on the screen

	CheckConsoleSize:
		INVOKE VerifyConsoleSize, targetRows, targetCols
		cmp  bl, 1
		je   CorrectConsoleSize ; Console size is correct

		; Notify user that console size does not match
		mWriteLn <"Console size (Rows, Col) does not match target!">

		; Print target console size
		INVOKE PrintCoordinate, ADDR consoleSizeTargetName, targetRows, targetCols

		; Move rows and cols to EAX and EBX
		; so INVOKE does not have to widen them
		call  GetMaxXY
		movzx eax, al
		movzx ebx, dl

		; Print actual console size
		INVOKE PrintCoordinate, ADDR consoleSizeActualName, eax, ebx

		; Prompt the user to resize the console
		mWriteLn <"Please resize the console window and press any key to continue!">
		call Crlf

		; Wait for user to press a key, then try again
		call ReadChar
		jmp  CheckConsoleSize

	CorrectConsoleSize:
		call Clrscr ; In case any prompts were put on the screen
		ret
ConsoleSizePrompt ENDP

END
