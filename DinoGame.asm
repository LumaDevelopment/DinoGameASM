; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc

.data

consoleTitle BYTE "chrome://dino",0

.code

main PROC
	; Ensure the console size is correct
	INVOKE ConsoleSizePrompt, TARGET_ROWS, TARGET_COLS

	; Set timer resolution to 1 ms
	call IncreaseTimerResolution

	; Initialize screen buffer
	call InitScreen

	; Attempt to load terrain from file into array
	call LoadTerrain
	cmp bl, 1
	jne FailedToLoadTerrain ; Attempt failed

	; Start keeping score
	call RecordStartTime

	; Use EBX to get number of ticks
	mov ebx,0

	; Main loop
	GameTick:
		; Store the tick start time
		push eax
		INVOKE GetTickLength,ebx
		INVOKE TickStartForDelay,eax
		pop eax

		; Set console title
		pushad
		INVOKE SetConsoleTitle, ADDR consoleTitle
		popad

		; Render this frame
		INVOKE WriteTerrain, TARGET_ROWS
		INVOKE GetCurrentJumpHeight, ebx
		call DrawObstacle
		INVOKE DrawCurrentDino, al

		call RenderScreen

		; Get user input and use it to affect dino
		call GetUserInput
		INVOKE DinoOnTick, ebx, al

		; Other per-tick procedures
		call IncrementTerrain
		; TODO ObstacleOnTick

		; TODO Physics?

		; Delay until the tick end time
		call DelayUntilTickEnd

		; Increment # of ticks, start next tick
		inc ebx
		jmp GameTick
	jmp EndDinoGame

	FailedToLoadTerrain:
		mWrite <"Could not load terrain file!",0dh,0ah>
		jmp EndDinoGame

	EndDinoGame:
		exit
main ENDP
END main
