INCLUDE DinoGame.inc

CACTUS_POS_Y = 1
CACTUS_WIDTH = 12
CACTUS_HEIGHT = 13

PTERO_POS_Y = 8
PTERO_WIDTH = 21
PTERO_HEIGHT = 8

.data

cactusSprite BYTE "    ####","n",
                  " ## ####","n",
                  "### ####","n",
                  "### #### ###","n",
                  "### #### ###","n",
                  "######## ###","n",
                  "######## ###","n",
                  "   ########","n",
                  "    ####","n",
                  "    ####","n",
                  "    ####","n",
                  "    ####","n",
                  "    ####",0

pteroSprite1 BYTE "   ###","n",
                  " ######","n",
                  "###############","n",
                  "       ##############","n",
                  "        ############","n",
                  "        #########","n",
                  "        ###","n",
                  "        ##",0

pteroSprite2 BYTE "       #","n",
                  "       ###","n",
                  "   ###  ####","n",
                  "  ##### #####","n",
                  "##############","n",
                  "      ###############","n",
                  "        ############","n",
                  "          #######",0

; Obstacle state tracking variables
currentObstacle BYTE  0 ; 0 = none, 1 = cactus, 2 = pterodactyl
obstaclePosX    BYTE  ?
obsStartingCol  DWORD ?
obsEndingCol    DWORD ?
obsBounds       BoundingBox <<,>,,>
currentPtero     BYTE  1 ; Alternates between 1 and 2

.code

DrawObstacle PROC
     cmp currentObstacle,0
     je EndOfProcedure ; Nothing to draw if no obstacle
     cmp currentObstacle,1
     je DrawCactus
     jmp DrawPterodactyl

     DrawCactus:
          INVOKE DrawSprite, ADDR cactusSprite, obstaclePosX, CACTUS_POS_Y, obsStartingCol, obsEndingCol
          jmp EndOfProcedure

     DrawPterodactyl:
          cmp currentPtero,1
          jne DrawPterodactylTwo

          DrawPterodactylOne:
               INVOKE DrawSprite, ADDR pteroSprite1, obstaclePosX, PTERO_POS_Y, obsStartingCol, obsEndingCol
               jmp EndOfProcedure

          DrawPterodactylTwo:
               INVOKE DrawSprite, ADDR pteroSprite2, obstaclePosX, PTERO_POS_Y, obsStartingCol, obsEndingCol

     EndOfProcedure:
          ret
DrawObstacle ENDP

UpdateObstacleBounds PROC USES eax
     cmp currentObstacle,0
     je EndOfProcedure ; Nothing to update if no obstacle
     
     GroundWork:
          ; Obstacle-agnostic bounding box updates

          mov al,obstaclePosX
          mov obsBounds.Position.X,al

          mov eax,obsEndingCol
          sub eax,obsStartingCol
          mov obsBounds.BoxWidth,al

          ; Jump to correct obstacle
          cmp currentObstacle,1
          je CactusBounds
          jmp PteroBounds

     CactusBounds:
          mov obsBounds.Position.Y, CACTUS_POS_Y
          mov obsBounds.BoxHeight,  CACTUS_HEIGHT
          jmp EndOfProcedure

     PteroBounds:
          mov obsBounds.Position.Y, PTERO_POS_Y
          mov obsBounds.BoxHeight,  PTERO_HEIGHT

     EndOfProcedure:
          ret
UpdateObstacleBounds ENDP

END
