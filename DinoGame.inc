INCLUDE Irvine32.inc
INCLUDE Macros.inc

; Moved here because needs to be accessible 
; by the Screen file

TARGET_ROWS = 30
TARGET_COLS = 120

; Utilities.asm

PrintCoordinate PROTO,
     coordLabel:PTR BYTE,
     X:DWORD,
     Y:DWORD

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
