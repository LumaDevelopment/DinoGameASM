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

.code

DrawCactus PROC
     INVOKE DrawSprite, ADDR cactusSprite, 100, CACTUS_POS_Y, 0, 0FFFFFFFFh
     ret
DrawCactus ENDP

END
