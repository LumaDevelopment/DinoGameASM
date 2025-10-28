; Manages terrain for the dino game.

INCLUDE DinoGame.inc

TERRAIN_LAYER_LEN = 1200
FULL_TERRAIN_LEN = 7200 ; 6 terrain layers

.data

terrainFilename BYTE   "terrain.txt",0
fileHandle      HANDLE ?
terrain         BYTE   FULL_TERRAIN_LEN DUP(?) ; 6 terrain layers, each with 1200 characters
incTerrainByte  BYTE   ?

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
          mov  bl,0
          jmp  close_file

     check_buffer_size:
          cmp eax,FULL_TERRAIN_LEN
          je  buf_size_ok
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

; Given the length of the screen, wipes rows of the 
; screen until terrain appears, then sets rows of 
; the screen equal to the layers of the terrain
WriteTerrain PROC USES eax ebx ecx edx,
     screenLength:BYTE

     ; Print # of blank lines = # of rows on screen - 6
     mov al,0
     WipeRow:
          INVOKE WipeRowInScreen, al
          inc al
          cmp al,screenLength-6
          jne WipeRow

     ; Now copy each terrain layer into the last 6 rows
     ; Starting row = screenLength - 6
     mov al,screenLength
     sub al,6
     mov ebx,0 ; layer counter

     SetTerrainLayer:
          ; Compute pointer to layer in terrain
          mov  ecx,ebx
          imul ecx,TERRAIN_LAYER_LEN
          mov  edx,OFFSET terrain
          add  edx,ecx

          ; call SetRowInScreen
          INVOKE SetRowInScreen, al, edx

          ; Increment counters
          inc al
          inc ebx

          ; Check if continue
          cmp ebx,6
          jne SetTerrainlayer
  
     ret
WriteTerrain ENDP

; For each layer of the terrain, saves the first byte,
; moves the next 1199 left by one, then places the saved 
; byte at the 1200th location of the layer.
; Creates an infinitely looping terrain effect.
IncrementTerrain PROC USES eax ebx ecx edx esi edi
     mov ebx, 0 ; Use this to count layers.

     IncrementLayer:
          ; Calculate offset to current layer
          mov eax, ebx
          imul eax, TERRAIN_LAYER_LEN

          ; Save first byte of this layer
          movzx edx, BYTE PTR terrain[eax]
          mov incTerrainByte, dl
          
          ; Move 1199 bytes left by one position
          cld
          mov ecx,TERRAIN_LAYER_LEN - 1
          lea esi,terrain[eax + 1] ; Source: second byte of layer
          lea edi,terrain[eax]     ; Dest:   first byte of layer
          rep movsb

          ; Set 1200th byte for that layer
          mov eax, ebx
          imul eax, TERRAIN_LAYER_LEN
          add eax, TERRAIN_LAYER_LEN - 1
          mov dl, incTerrainByte
          mov terrain[eax], dl

          ; Increment layer counter
          inc ebx

          ; Check if last layer
          cmp ebx,6
          jne IncrementLayer

     ret
IncrementTerrain ENDP

END
