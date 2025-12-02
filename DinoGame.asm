; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc

.data

consoleTitle BYTE "chrome://dino",0

.code

main PROC
	; Ensure the console size is correct
	INVOKE ConsoleSizePrompt, TARGET_ROWS, TARGET_COLS

	; Initialize starting seed value of Irvine random procedures
	call Randomize

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

		; Get user input and use it to affect dino
		call GetUserInput
		INVOKE DinoOnTick, ebx, al

		; Update everything obstacles!
		INVOKE ObstacleOnTick, ebx

		; Draw everything to be rendered
		INVOKE WriteTerrain, TARGET_ROWS
		call DrawObstacle
		INVOKE DrawCurrentDino, ebx

		; Render this tick
		call RenderScreen

		; TODO Physics?

		; Infinitely looping terrain
		call IncrementTerrain

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
