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
pteroSprite     BYTE  1 ; Alternates between 1 and 2

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
          cmp pteroSprite,1
          jne DrawPterodactylTwo

          DrawPterodactylOne:
               INVOKE DrawSprite, ADDR pteroSprite1, obstaclePosX, PTERO_POS_Y, obsStartingCol, obsEndingCol
               jmp EndOfProcedure

          DrawPterodactylTwo:
               INVOKE DrawSprite, ADDR pteroSprite2, obstaclePosX, PTERO_POS_Y, obsStartingCol, obsEndingCol

     EndOfProcedure:
          ret
DrawObstacle ENDP

END
