; chrome://dino, adapted to Assembly

INCLUDE DinoGame.inc

.data

consoleTitle BYTE "chrome://dino",0

.code

main PROC
	; Set console title
	INVOKE SetConsoleTitle, ADDR consoleTitle

	; Ensure the console size is correct
	INVOKE ConsoleSizePrompt, TARGET_ROWS, TARGET_COLS

	; Initialize screen
	call InitScreen

	; Attempt to load terrain from file into array
	call LoadTerrain
	cmp bl, 1
	jne FailedToLoadTerrain ; Attempt failed

	; Start keeping score
	call RecordStartTime

	; Use EBX to get number of renders
	mov ebx,0

	; Test rotating terrain
	RenderLoop:
		; Decide whether to flip the dino
		mov eax,ebx
		mov edx,0
		mov ecx,10
		div ecx
		cmp edx,0
		jne RenderStep
		call FlipCurrentDino

	RenderStep:
		; Render this frame
		INVOKE WriteTerrain, TARGET_ROWS
		INVOKE DrawCurrentDino, 0
		call RenderScreen

		; Infinitely looping terrain
		call IncrementTerrain

		; Delay so it can be visible
		mov eax, 10
		call Delay

		inc ebx
		jmp RenderLoop
	jmp EndDinoGame

	FailedToLoadTerrain:
		mWrite <"Could not load terrain file!",0dh,0ah>
		jmp EndDinoGame

	EndDinoGame:
		exit
main ENDP
END main
