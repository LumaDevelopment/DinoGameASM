INCLUDE DinoGame.inc

DINO_POS_X = 2
DINO_POS_Y = 1
DINO_WIDTH = 20
DINO_HEIGHT = 11

TICKS_PER_DINO_SPRITE = 10

.data

; Drawing data

currentDino BYTE 1

dino1 BYTE "          ##########","n",
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

dino2 BYTE "          ##########","n",
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

; Jumping data

lastJumpStarted DWORD 0
jumpCurve       BYTE  1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,9,9,9,9,9,9,9,9,9,9,8,8,7,7,6,6,5,5,4,4,3,3,2,2,1,1

.code

DrawDino PROC USES eax ebx ecx edx esi,
     dinoAddr:PTR BYTE,
     distanceFromGround:BYTE

     ; Keep track of rows using EAX, 
     ; columns using EBX, and raw 
     ; character index using esi
     mov eax,0
     mov ebx,0
     mov esi,0

     ; Loop through every pixel of the dino,
     ; not drawing anything on spaces,
     ; dropping down to next row on 'n'
     ; and terminating on 0

     NewPixel:
          mov edx, [dinoAddr]
          mov dl, [edx + esi]

          ; On space, skip draw
          cmp dl,' '
          je IncrementColumn

          ; On 'n', increment line
          cmp dl,'n'
          je NewLine

          ; On 0, end draw
          cmp dl,0
          je EndOfProcedure

          ; Otherwise, draw the pixel

     DrawPixel:
          ; Use high byte of DX for row index
          mov dh,al
          add dh,TARGET_ROWS
          sub dh,DINO_POS_Y
          sub dh,DINO_HEIGHT
          sub dh,distanceFromGround

          ; Use ECX for column index
          mov cl,bl
          add cl,DINO_POS_X

          ; Save ESI and use it for character address
          push esi
          add esi,dinoAddr

          ; Save EAX, because it gets modified by the INVOKE
          push eax

          INVOKE SetPixelInScreen, dh, cl, esi

          ; Restore registers
          pop eax
          pop esi

     IncrementColumn:
          inc ebx
          jmp NextPixel

     NewLine:
          inc eax
          mov ebx,0
          jmp NextPixel

     NextPixel:
          inc esi
          jmp NewPixel

     EndOfProcedure:
          ret
DrawDino ENDP

; Draws either dino 1 or 2, depending on the current dino
DrawCurrentDino PROC,
     distanceFromGround:BYTE

     cmp currentDino,1
     je DrawDinoOne
     jmp DrawDinoTwo

     DrawDinoOne:
          INVOKE DrawDino, ADDR dino1, distanceFromGround
          jmp EndOfProcedure

     DrawDinoTwo:
          INVOKE DrawDino, ADDR dino2, distanceFromGround

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

; Procedure that handles any changes that should be 
; made to the dino spirte or current action on any 
; given tick
DinoOnTick PROC USES eax ecx edx,
     currentTick:DWORD,
     userInput:BYTE

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
          jne EndOfProcedure

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

     EndOfProcedure:
          ret
DinoOnTick ENDP

END
