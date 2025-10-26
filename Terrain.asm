; Manages terrain for the dino game.

INCLUDE DinoGame.inc

TERRAIN_LAYER_LEN = 1200
FULL_TERRAIN_LEN = 7200 ; 6 terrain layers

.data

terrainFilename BYTE "terrain.txt",0
fileHandle      HANDLE ?

; 6 terrain layers, each with 1200 characters
terrain BYTE FULL_TERRAIN_LEN DUP(?)

.code

; Attempts to load the terrain from a text file into the 
; terrain array. Return: bl = 1 if this is successful, 
; bl = 0 otherwise.
; HEAVILY based on the 'ReadFile Program Example' on 
; pages 471 & 472 of Irvine 7th edition.
LoadTerrain PROC USES eax ecx edx
     ; Open the file for input
     mov  edx,OFFSET terrainFilename
     call OpenInputFile
     mov  fileHandle, eax

     ; Check for errors
     cmp eax,INVALID_HANDLE_VALUE
     jne file_ok
     mWrite <"Cannot open terrain file",0dh,0ah>
     mov bl,0
     jmp quit

     file_ok:
          ; Read the file into the terrain array
          mov  edx,OFFSET terrain
          mov  ecx,FULL_TERRAIN_LEN
          call ReadFromFile
          jnc  check_buffer_size
          mWrite "Error reading terrain file. "
          call WriteWindowsMsg
          mov bl,0
          jmp  close_file

     check_buffer_size:
          cmp eax,FULL_TERRAIN_LEN
          je buf_size_ok
          mWrite <"Error: Bytes read does not equal terrain length!",0dh,0ah>
          mov bl, 0
          jmp quit

     buf_size_ok:
          mov bl, 1

     close_file:
          mov  eax,fileHandle
          call CloseFile

     quit:
          ret
LoadTerrain ENDP

; Given the dimensions of the screen, writes blank lines 
; until ready to write terrain, then writes from the 
; terrain layers. Should be the first step of rendering 
; a frame.
WriteTerrain PROC USES ecx,
     screenLength:BYTE,
     screenWidth:BYTE

     ; Print # of blank lines = # of rows on screen - 6
     movzx ecx, screenLength
     sub ecx, 6

     PrintBlankLine:
          call Crlf
          loop PrintBlankLine

     ; Move screenWidth to 32-bit register 
     ; so it matches parameter type
     movzx ecx, screenWidth

     ; TODO Print terrain

     ret
WriteTerrain ENDP

END
