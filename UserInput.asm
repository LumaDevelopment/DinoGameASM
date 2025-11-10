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
     jz NoInput

     ; space is jump
     cmp al,' '
     je DinoJump

     ; all other inputs are 'extended keys', 
     ; so if AL != 0, then we are not interested
     cmp al,0
     jne NoInput

     ; dx = 38 -> up arrow key -> jump
     UpArrowKeyCheck:
          cmp dx,38
          jne DownArrowKeyCheck

          jmp DinoJump

     ; TODO Instead of this, use Irvine pg. 460
     ; "Getting the Keyboard State" to determine 
     ; if the user is holding the down arrow key

     ; dx = 40 -> down arrow key -> crouch
     DownArrowKeyCheck:
          cmp dx,40
          jne NoInput

          jmp DinoCrouch

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
