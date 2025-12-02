INCLUDE DinoGame.inc

CACTUS_WIDTH = 12
CACTUS_HEIGHT = 13
CACTUS_STARTING_X = 108

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

.code

DrawCactus PROC
     INVOKE DrawSprite, ADDR cactusSprite, 108, 1
     ret
DrawCactus ENDP

END
