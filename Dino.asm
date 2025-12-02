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
jumpCurve       BYTE  1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,9,9,9,9,9,9,9,9,9,9,8,8,7,7,6,6,5,5,4,4,3,3,2,2,1,1

; Crouching data

isDinoCrouching BYTE 0

; Physics data

dinoBounds BoundingBox <<DINO_POS_X, DINO_POS_Y>, DINO_RUNNING_WIDTH, DINO_RUNNING_HEIGHT>

.code

; Draws the current dino sprite, factoring in `currentDino`
; and whether the dino is currently crouching.
DrawCurrentDino PROC USES eax,
     distanceFromGround:BYTE

     ; Calculate dino Y position
     mov al,DINO_POS_Y
     add al,distanceFromGround

     ; Decide which dino to draw
     cmp currentDino,1
     je DrawDinoOne
     jmp DrawDinoTwo

     DrawDinoOne:
          cmp isDinoCrouching,1
          je DrawCrouchingDinoOne

          DrawRunningDinoOne:
               INVOKE DrawSprite, ADDR dinoRunning1, DINO_POS_X, al
               jmp EndOfProcedure

          DrawCrouchingDinoOne:
               INVOKE DrawSprite, ADDR dinoCrouching1, DINO_POS_X, al
               jmp EndOfProcedure

     DrawDinoTwo:
          cmp isDinoCrouching,1
          je DrawCrouchingDinoTwo

          DrawRunningDinoTwo:
               INVOKE DrawSprite, ADDR dinoRunning2, DINO_POS_X, al
               jmp EndOfProcedure

          DrawCrouchingDinoTwo:
               INVOKE DrawSprite, ADDR dinoCrouching2, DINO_POS_X, al
               jmp EndOfProcedure

     EndOfProcedure:
          ret
DrawCurrentDINO ENDP

; If current dino is 1, flips it to dino 2, and vice versa.
FlipCurrentDino PROC
     cmp currentDino,1
     je  FlipToDinoTwo
     jmp FlipToDinoOne

     FlipToDinoTwo:
          inc currentDino
          jmp EndOfProcedure

     FlipToDinoOne:
          dec currentDino

     EndOfProcedure:
          ret
FlipCurrentDino ENDP

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
     cmp ecx,LENGTHOF jumpCurve
     jae OnGround

     OffGround:
          mov al, BYTE PTR jumpCurve[ecx]
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
          call FlipCurrentDino

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
          cmp ecx,LENGTHOF jumpCurve
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
