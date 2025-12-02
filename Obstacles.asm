INCLUDE DinoGame.inc

SAFE_TICKS = 50

; On each tick where an obstacle does not exist, 
; there is a 1 in SPAWN_PROBABILITY chance an 
; obstacle spawns
SPAWN_PROBABILITY = 75

CACTUS_POS_Y = 1
CACTUS_WIDTH = 12
CACTUS_HEIGHT = 13

PTERO_POS_Y = 8
PTERO_WIDTH = 21
PTERO_HEIGHT = 8
TICKS_PER_PTERO_SPRITE = 20

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
currentPtero    BYTE  1 ; Alternates between 1 and 2

.code

DrawObstacle PROC
     pushad ; Preserve registers

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
          popad ; Preserve registers
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

MoveObstacleLeft PROC USES eax
     cmp currentObstacle,0
     je EndOfProcedure

     ; Load obstacle width into eax
     LoadObstacleWidth:
          cmp currentObstacle,1
          je  LoadCactusWidth
          jmp LoadPteroWidth

          LoadCactusWidth:
               mov eax,CACTUS_WIDTH
               jmp DecideMovementType

          LoadPteroWidth:
               mov eax,PTERO_WIDTH
               jmp DecideMovementType

     DecideMovementType:
          cmp obsEndingCol,eax
          jb EnterFromRight
          cmp obstaclePosX,0
          ja MovingAcrossScreen
          jmp LeavingFromLeft

     EnterFromRight:
          ; Move obstacle to the left and add 
          ; another column to be drawn
          dec obstaclePosX
          inc obsEndingCol
          jmp EndOfProcedure

     MovingAcrossScreen:
          ; Move obstacle to the left
          dec obstaclePosX
          jmp EndOfProcedure

     LeavingFromLeft:
          ; Drop a column from being drawn
          inc obsStartingCol

          ; Determine whether obstacle is 
          ; off screen yet
          mov eax,obsStartingCol
          cmp eax,obsEndingCol
          je OffScreen
          jmp EndOfProcedure

     OffScreen:
          ; Destroy obstacle by clearing currentObstacle
          mov currentObstacle,0

     EndOfProcedure:
          ret
MoveObstacleLeft ENDP

InstantiateObstacle PROC USES eax,
     obstacleType:BYTE ; 1 = cactus, 2 = pterodactyl

     ; Set obstacle type
     mov al,obstacleType
     mov currentObstacle,al

     ; Set starting position
     mov obstaclePosX,TARGET_COLS
     dec obstaclePosX

     ; Set starting column range
     mov obsStartingCol,0
     mov obsEndingCol,1

     ret
InstantiateObstacle ENDP

ObstacleOnTick PROC USES eax ecx edx,
     currentTick:DWORD

     ; Let the user get their bearings at
     ; the start
     DetermineIfSafe:
          cmp currentTick,SAFE_TICKS
          jbe EndOfProcedure

     DoesObstacleExist:
          cmp currentObstacle,0
          jne ObstacleAlreadyExists

     ObstacleDNE:
          ; Determine whether to spawn an obstacle
          mov eax,SPAWN_PROBABILITY
          call RandomRange
          cmp eax,0
          je SpawnObstacle

          ; Do not do anything else this tick if no
          ; obstacle is spawned
          jmp EndOfProcedure

     SpawnObstacle:
          ; Determine whether to spawn a cactus 
          ; or a pterodactyl
          mov eax,2
          call RandomRange
          inc eax ; Ensures EAX in [1, 2]
          INVOKE InstantiateObstacle,al ; Spawn obstacle
          jmp UpdateBoundingBox

     ObstacleAlreadyExists:
          ; If obstacle already exists, shift it
          call MoveObstacleLeft

     UpdateBoundingBox:
          ; Update for physics
          call UpdateObstacleBounds

          ; If this is a pterodactyl, we want 
          ; to flip the sprite every once in 
          ; a while
          cmp currentObstacle,1
          je EndOfProcedure

     PteroSpriteManagement:
          ; Flip pterodactyl sprite if
          ; currentTick % TICKS_PER_PTERO_SPRITE = 0
          mov eax,currentTick
          mov edx,0
          mov ecx,TICKS_PER_PTERO_SPRITE
          div ecx
          cmp edx,0
          jne EndOfProcedure

          ; Flip sprite!
          INVOKE FlipCurrentSprite, ADDR currentPtero

     EndOfProcedure:
          ret
ObstacleOnTick ENDP

END
