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

WriteCharsFromString PROTO,
     string:PTR BYTE,
     len:DWORD

; ConsoleSizeMgmt.asm

VerifyConsoleSize PROTO,
     targetRows:BYTE,
     targetCols:BYTE

ConsoleSizePrompt PROTO,
     targetRows:BYTE,
     targetCols:BYTE

; Terrain.asm

LoadTerrain PROTO

WriteTerrain PROTO,
     screenLength:BYTE,
     screenWidth:BYTE

IncrementTerrain PROTO
