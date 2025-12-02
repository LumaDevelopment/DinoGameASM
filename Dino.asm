INCLUDE DinoGame.inc

DINO_POS_X = 2
DINO_POS_Y = 1
DINO_RUNNING_WIDTH = 20
DINO_RUNNING_HEIGHT = 11
DINO_CROUCHING_WIDTH = 26
DINO_CROUCHING_HEIGHT = 6

TICKS_PER_DINO_SPRITE = 10

.data

; Drawing data

currentDino BYTE 1

dinoRunning1 BYTE "          ##########","n",
                  "          ##########","n",
                  "          ##########","n",
                  "          ########","n",
                  "#      #######","n",
                  "###  ######### #","n",
                  "##############","n",
                  " ############","n",
                  "   #########","n",
                  "     ###  ###","n",
                  "     ##",0

dinoRunning2 BYTE "          ##########","n",
                  "          ##########","n",
                  "          ##########","n",
                  "          ########","n",
                  "#      #######","n",
                  "###  ######### #","n",
                  "##############","n",
                  " ############","n",
                  "   #########","n",
                  "     ### ##","n",
                  "          ##",0

dinoCrouching1 BYTE "###   #########  ########","n",
                    " #########################","n",
                    "   #######################","n",
                    "     ########### #######","n",
                    "     #  ###   ##","n",
                    "        ##",0

dinoCrouching2 BYTE "###   #########  ########","n",
                    " #########################","n",
                    "   #######################","n",
                    "     ########### #######","n",
                    "     ###  ##  ##","n",
                    "     ##",0

; Jumping data

lastJumpStarted DWORD 0

TICKS_PER_ASCENT = 2
PEAK_DINO_HEIGHT = 15
TICKS_AT_PEAK = 18
TICKS_PER_DESCENT = 2

PEAK_START_TICK = (PEAK_DINO_HEIGHT - 1) * TICKS_PER_ASCENT
DESCENT_START_TICK = PEAK_START_TICK + TICKS_AT_PEAK
DESCENT_END_TICK = DESCENT_START_TICK + ((PEAK_DINO_HEIGHT - 1) * TICKS_PER_DESCENT)

; Crouching data

isDinoCrouching BYTE 0

; Physics data

dinoBounds BoundingBox <<DINO_POS_X, DINO_POS_Y>, DINO_RUNNING_WIDTH, DINO_RUNNING_HEIGHT>

.code

; Draws the current dino sprite, factoring in `currentDino`
; and whether the dino is currently crouching.
DrawCurrentDino PROC USES eax,
     currentTick:DWORD

     ; Load distance from ground into AL
     INVOKE GetCurrentJumpHeight,currentTick

     ; Calculate dino Y position
     add al,DINO_POS_Y

     ; Decide which dino to draw
     cmp currentDino,1
     je DrawDinoOne
     jmp DrawDinoTwo

     DrawDinoOne:
          cmp isDinoCrouching,1
          je DrawCrouchingDinoOne

          DrawRunningDinoOne:
               INVOKE DrawSprite, ADDR dinoRunning1, DINO_POS_X, al, 0, 0FFFFFFFFh
               jmp EndOfProcedure

          DrawCrouchingDinoOne:
               INVOKE DrawSprite, ADDR dinoCrouching1, DINO_POS_X, al, 0, 0FFFFFFFFh
               jmp EndOfProcedure

     DrawDinoTwo:
          cmp isDinoCrouching,1
          je DrawCrouchingDinoTwo

          DrawRunningDinoTwo:
               INVOKE DrawSprite, ADDR dinoRunning2, DINO_POS_X, al, 0, 0FFFFFFFFh
               jmp EndOfProcedure

          DrawCrouchingDinoTwo:
               INVOKE DrawSprite, ADDR dinoCrouching2, DINO_POS_X, al, 0, 0FFFFFFFFh
               jmp EndOfProcedure

     EndOfProcedure:
          ret
DrawCurrentDINO ENDP

; Get the current height of the dino off the ground 
; given `lastJumpStarted`.
; Returns in AL.
GetCurrentJumpHeight PROC USES ecx,
     currentTick:DWORD

     ; If lastJumpStarted = 0, assume dino on ground
     cmp lastJumpStarted,0
     je OnGround

     ; Otherwise, calculate number of ticks elapsed 
     ; since last jump
     mov ecx,currentTick
     sub ecx,lastJumpStarted

     ; Determine whether the dino is off the ground or not
     cmp ecx,DESCENT_END_TICK
     jae OnGround

     DetermineJumpPhase:
          cmp ecx,PEAK_START_TICK
          jb Ascending
          cmp ecx,DESCENT_START_TICK
          jb AtPeak
          jmp Descending

     Ascending:
          push eax
          mov ax,cx
          mov cl,TICKS_PER_ASCENT
          jmp BeginDividing

     AtPeak:
          mov al,PEAK_DINO_HEIGHT
          jmp EndOfProcedure

     Descending:
          push eax
          mov ax,DESCENT_END_TICK
          sub ax,cx ; Subtract from end instead of divide elapsed
          mov cl,TICKS_PER_DESCENT

     BeginDividing:
          ; Accept dividend in AX and divisor in CL
          div cl ; Divide ticks elapsed by ascent/descent rate

          cmp ah,0
          je EndDividing ; No round up required if remainder is 0
          inc al         ; Round up if remainder

     EndDividing:
          mov cl,al ; move quotient into cl
          pop eax   ; restore EAX
          mov al,cl ; move quotient back into al
          jmp EndOfProcedure

     OnGround:
          mov al,0

     EndOfProcedure:
          ret
GetCurrentJumpHeight ENDP

UpdateDinoBounds PROC USES eax,
     currentTick:DWORD

     ; In all cases we will need to set these values
     ; X VALUE NEVER CHANGES
     mov dinoBounds.Position.Y, DINO_POS_Y

     ; Determine if the dino is crouching
     ; or if we need to check jump height
     cmp isDinoCrouching,1
     je DinoIsCrouching
     jmp DinoRunningOrJumping

     DinoIsCrouching:
          mov dinoBounds.BoxWidth,  DINO_CROUCHING_WIDTH
          mov dinoBounds.BoxHeight, DINO_CROUCHING_HEIGHT
          jmp EndOfProcedure

     DinoRunningOrJumping:
          ; Add jump height (if any)
          INVOKE GetCurrentJumpHeight, currentTick
          add dinoBounds.Position.Y, al

          ; Running sprite bounds
          mov dinoBounds.BoxWidth,  DINO_RUNNING_WIDTH
          mov dinoBounds.BoxHeight, DINO_RUNNING_HEIGHT

     EndOfProcedure:
          ret
UpdateDinoBounds ENDP

; Procedure that handles any changes that should be 
; made to the dino spirte or current action on any 
; given tick
DinoOnTick PROC USES eax ecx edx,
     currentTick:DWORD,
     userInput:BYTE

     ; Assume not crouching unless stated otherwise
     mov isDinoCrouching,0

     ; First order of business is to determine whether
     ; to flip the dino sprite
     DetermineFlip:
          ; Do not flip sprite if dino is jumping
          INVOKE GetCurrentJumpHeight, currentTick
          cmp al,0
          jne UserInputCheck
          
          ; If dino is not jumping, then flip if 
          ; currentTick % TICKS_PER_DINO_SPRITE = 0
          mov eax,currentTick
          mov edx,0
          mov ecx,TICKS_PER_DINO_SPRITE
          div ecx
          cmp edx,0
          jne UserInputCheck
          INVOKE FlipCurrentSprite, ADDR currentDino

     UserInputCheck:
          ; Determine whether the user wants the dino 
          ; to jump
          cmp userInput,DINO_JUMP
          je OnJumpRequested
          cmp userInput,DINO_CROUCH
          je OnCrouchRequested
          jmp EndOfProcedure

     OnJumpRequested:
          ; Can definitely jump if lastJumpStarted = 0
          cmp lastJumpStarted,0
          je CanJumpAgain

          ; Calc ticks elapsed since last jump
          mov ecx,currentTick
          sub ecx,lastJumpStarted
          cmp ecx,DESCENT_END_TICK
          jbe EndOfProcedure ; cannot jump again

     CanJumpAgain:
          ; Update when last jump started
          mov ecx,currentTick
          mov lastJumpStarted,ecx
          jmp EndOfProcedure

     OnCrouchRequested:
          ; Cannot crouch while jumping, so get
          ; current jump height
          INVOKE GetCurrentJumpHeight, currentTick
          cmp al,0
          jne EndOfProcedure ; dino is mid-jump

          ; Activate crouch, set flag
          mov isDinoCrouching,1

     EndOfProcedure:
          INVOKE UpdateDinoBounds, currentTick
          ret
DinoOnTick ENDP

END
