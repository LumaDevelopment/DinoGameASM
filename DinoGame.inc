INCLUDE Irvine32.inc
INCLUDE Macros.inc

; Add the ability to set the timer resolution

extern timeBeginPeriod@4: proc

; ----- USER INPUT -----

NO_DINO_INPUT = 0
DINO_JUMP = 1
DINO_CROUCH = 2

; ----- SCREEN SIZE -----

TARGET_ROWS = 30
TARGET_COLS = 120

; ----- PROCEDURES -----

; ConsoleSizeMgmt.asm

VerifyConsoleSize PROTO,
     targetRows:BYTE,
     targetCols:BYTE

ConsoleSizePrompt PROTO,
     targetRows:BYTE,
     targetCols:BYTE

; Dino.asm

DrawCurrentDino PROTO,
     currentTick:DWORD

GetCurrentJumpHeight PROTO,
     currentTick:DWORD

DinoOnTick PROTO,
     currentTick:DWORD,
     userInput:BYTE

; GameSpeed.asm

GetTickLength PROTO,
     currentTick:DWORD

; Obstacles.asm

DrawObstacle PROTO

MoveObstacleLeft PROTO

InstantiateObstacle PROTO,
     obstacleType:BYTE

ObstacleOnTick PROTO,
     currentTick:DWORD

; Score.asm

RecordStartTime PROTO

RecordEndTime PROTO

GetScore PROTO

; Screen.asm

InitScreen PROTO

SetRowInScreen PROTO,
     rowIndex:BYTE,
     rowText:PTR BYTE

WipeRowInScreen PROTO,
     rowIndex:BYTE

WipeScreen PROTO

SetPixelInScreen PROTO,
     rowIndex:BYTE,
     colIndex:BYTE,
     charPointer:PTR BYTE

RenderScreen PROTO

; Terrain.asm

LoadTerrain PROTO

WriteTerrain PROTO,
     screenLength:BYTE

IncrementTerrain PROTO

; TickDelay.asm

IncreaseTimerResolution PROTO

TickStartForDelay PROTO,
     delayInMs:DWORD

DelayUntilTickEnd PROTO

; UserInput.asm

GetUserInput PROTO

; Utilities.asm

CalculateSpriteHeight PROTO,
     spriteAddr:PTR BYTE

CalculateTickDelta PROTO,
     startTime:DWORD,
     endTime:DWORD

DrawSprite PROTO,
     spriteAddr:PTR BYTE,
     spriteBaseX:BYTE,
     spriteBaseY:BYTE,
     startingCol:DWORD,
     endingCol:DWORD

FlipCurrentSprite PROTO,
     currentSpriteVar:PTR BYTE

PrintCoordinate PROTO,
     coordLabel:PTR BYTE,
     X:DWORD,
     Y:DWORD
