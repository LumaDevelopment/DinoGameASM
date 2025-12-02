; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc
EXTERN writeCollision:BYTE

.data

consoleTitle BYTE  "chrome://dino",0
endPauseInMs DWORD 2000

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

		; Determine if a collision occured
		cmp writeCollision,1
		je EndDinoGame

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
		; Stop counting score
		call RecordEndTime

		; Dramatic pause
		mov eax,endPauseInMs
		INVOKE Sleep,eax

		; Display score to screen and exit!
		call DisplayScore
		
		exit
main ENDP
END main
