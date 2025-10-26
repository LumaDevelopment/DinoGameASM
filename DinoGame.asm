; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc

TARGET_ROWS = 30
TARGET_COLS = 120

.code

main PROC
	; Ensure the console size is correct
	INVOKE ConsoleSizePrompt, TARGET_ROWS, TARGET_COLS

	; Print terrain
	INVOKE WriteTerrain, TARGET_ROWS, TARGET_COLS

	exit
main ENDP
END main
