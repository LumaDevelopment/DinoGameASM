INCLUDE Irvine32.inc

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

WriteTerrain PROTO,
     screenLength:BYTE,
     screenWidth:BYTE
