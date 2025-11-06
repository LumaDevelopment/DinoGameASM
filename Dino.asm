INCLUDE DinoGame.inc

DINO_POS_X = 1
DINO_POS_Y = 1
DINO_WIDTH = 20
DINO_HEIGHT = 11

.data

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

.code

DrawDino PROC USES eax ebx ecx edx esi,
     dinoAddr:PTR BYTE

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
          mov dh, al
          add dh,TARGET_ROWS
          sub dh,DINO_POS_Y
          sub dh,DINO_HEIGHT

          ; Use ECX for column index
          mov cl,bl
          add cl,DINO_POS_X

          ; Save ESI and use it for character address
          push esi
          add esi,dinoAddr

          ; Save EAX, because somehow it is being modified
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
DrawCurrentDino PROC
     cmp currentDino,1
     je DrawDinoOne
     jmp DrawDinoTwo

     DrawDinoOne:
          INVOKE DrawDino, ADDR dino1
          jmp EndOfProcedure

     DrawDinoTwo:
          INVOKE DrawDino, ADDR dino2

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

END
