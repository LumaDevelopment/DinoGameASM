; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc

.code

main PROC
	; Ensure the console size is correct
	INVOKE ConsoleSizePrompt, TARGET_ROWS, TARGET_COLS

	; Initialize screen
	call InitScreen

	; Attempt to load terrain from file into array
	call LoadTerrain
	cmp bl, 1
	jne FailedToLoadTerrain ; Attempt failed

	; Test rotating terrain
	TerrainLoop:
		; Render this frame
		INVOKE WriteTerrain, TARGET_ROWS
		call RenderScreen

		; Infinitely looping terrain
		call IncrementTerrain

		; Delay so it can be visible
		mov eax, 10
		call Delay

		jmp TerrainLoop
	jmp EndDinoGame

	FailedToLoadTerrain:
		mWrite <"Could not load terrain file!",0dh,0ah>
		jmp EndDinoGame

	EndDinoGame:
		exit
main ENDP
END main
