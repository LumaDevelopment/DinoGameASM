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

; ----- TYPES -----

Coordinate STRUCT
     X BYTE ?
     Y BYTE ?
Coordinate ENDS

; The physical representation of a given sprite.
; Used for collision calculations
BoundingBox STRUCT
     Position  Coordinate <>
     BoxWidth  BYTE       ?
     BoxHeight BYTE       ?
BoundingBox ENDS

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
     distanceFromGround: BYTE

FlipCurrentDino PROTO

GetCurrentJumpHeight PROTO,
     currentTick:DWORD

DinoOnTick PROTO,
     currentTick:DWORD,
     userInput:BYTE

; Obstacles.asm

DrawCactus PROTO

; Physics.asm

AreBoundingBoxesColliding PROTO,
     boxOne:BoundingBox,
     boxTwo:BoundingBox

; TickDelay.asm

IncreaseTimerResolution PROTO

TickStartForDelay PROTO,
     delayInMs:DWORD

DelayUntilTickEnd PROTO

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
     spriteBaseY:BYTE

PrintCoordinate PROTO,
     coordLabel:PTR BYTE,
     X:DWORD,
     Y:DWORD
