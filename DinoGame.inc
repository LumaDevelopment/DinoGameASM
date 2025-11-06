INCLUDE Irvine32.inc
INCLUDE Macros.inc

; SCREEN SIZE CONSTANTS

TARGET_ROWS = 30
TARGET_COLS = 120

; TYPES

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

; Score.asm

RecordStartTime PROTO

RecordEndTime PROTO

GetScore PROTO

; Utilities.asm

PrintCoordinate PROTO,
     coordLabel:PTR BYTE,
     X:DWORD,
     Y:DWORD

; Physics.asm

AreBoundingBoxesColliding PROTO,
     boxOne:BoundingBox,
     boxTwo:BoundingBox

; ConsoleSizeMgmt.asm

VerifyConsoleSize PROTO,
     targetRows:BYTE,
     targetCols:BYTE

ConsoleSizePrompt PROTO,
     targetRows:BYTE,
     targetCols:BYTE

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

; Dino.asm

DrawDino PROTO,
     dinoAddr:PTR BYTE,
     distanceFromGround:BYTE

DrawCurrentDino PROTO,
     distanceFromGround: BYTE

FlipCurrentDino PROTO
