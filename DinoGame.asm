; chrome://dino, adapted to Assembly
; Built for a console with 30 rows and 120 columns

INCLUDE Irvine32.inc

TARGET_ROWS = 30
TARGET_COLS = 120

.code

; Determines if the current console size equals the 
; target dimensions.
; Returns: BL = 1 if size matches, 0 otherwise
VerifyConsoleSize PROC USES eax edx
	call GetMaxXY
	cmp al, TARGET_ROWS
	jne Otherwise
	cmp dl, TARGET_COLS
	jne Otherwise

	Match:
		mov bl,1
		jmp Return
	Otherwise:
		mov bl,0
	Return:
		ret
VerifyConsoleSize ENDP

main proc
	call VerifyConsoleSize

	exit
main endp
end main