; Parses keys pressed into information about user 
; input the game can use.

INCLUDE DinoGame.inc

.code

; Determines if the user has commanded the dino, 
; and if so, what they command the dino to do.
; Returns NO_DINO_INPUT, DINO_JUMP, or DINO_CROUCH
; in EAX.
GetUserInput PROC USES ebx edx
     call ReadKey
     jz DownArrowKeyCheck

     ; space is jump
     cmp al,' '
     je DinoJump

     ; all other inputs are 'extended keys', 
     ; so if AL != 0, then we are not interested
     cmp al,0
     jne DownArrowKeyCheck

     ; dx = 38 -> up arrow key -> jump
     UpArrowKeyCheck:
          cmp dx,38
          jne DownArrowKeyCheck

          jmp DinoJump

     ; Jump button is not pressed, so see if the 
     ; user is holding the down arrow key
     DownArrowKeyCheck:
          ; Constant found in https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
          pushad
          INVOKE GetKeyState, VK_DOWN
          test eax,8000h ; book tests bit 31 instead of 15 for some reason
          popad
          jnz DinoCrouch ; zero flag not set = key is down

          jmp NoInput

     DinoJump:
          mov eax,DINO_JUMP
          jmp EndOfProcedure

     DinoCrouch:
          mov eax,DINO_CROUCH
          jmp EndOfProcedure

     NoInput:
          mov eax,NO_DINO_INPUT

     EndOfProcedure:
          ret
GetUserInput ENDP

END
