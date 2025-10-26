; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc

TARGET_ROWS = 30
TARGET_COLS = 120

.code

main PROC
	; Ensure the console size is correct
	INVOKE ConsoleSizePrompt, TARGET_ROWS, TARGET_COLS

	; Attempt to load terrain from file into array
	call LoadTerrain
	cmp bl, 1
	jne FailedToLoadTerrain ; Attempt failed

	; Test rotating terrain
	mov ecx, 2000
	TerrainLoop:
		INVOKE WriteTerrain, TARGET_ROWS, TARGET_COLS
		call IncrementTerrain

		loop TerrainLoop
	jmp EndDinoGame

	FailedToLoadTerrain:
		mWrite <"Could not load terrain file!",0dh,0ah>
		jmp EndDinoGame

	EndDinoGame:
		exit
main ENDP
END main
