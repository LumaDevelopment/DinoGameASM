; Manages terrain for the dino game.

INCLUDE DinoGame.inc

TERRAIN_LAYER_LEN = 1200

.data

; Stored individually so I can use rotate instructions
terrainLayer1 BYTE "                                                                                                                                                                                                        "
terrainLayer2 BYTE "                                                                                                                                                                                                        "
terrainLayer3 BYTE "========================================================================================================================================================================================================"
terrainLayer4 BYTE "                                                                                                                                                                                                        "
terrainLayer5 BYTE "      ....                                                                           .                ..                                                                              ..                "
terrainLayer6 BYTE "....          ..                         .      ....                  ..                  ....                            .              ..                                       .         ...         "

.code

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

     ; Print terrain
     INVOKE WriteCharsFromString, ADDR terrainLayer1, ecx
     INVOKE WriteCharsFromString, ADDR terrainLayer2, ecx
     INVOKE WriteCharsFromString, ADDR terrainLayer3, ecx
     INVOKE WriteCharsFromString, ADDR terrainLayer4, ecx
     INVOKE WriteCharsFromString, ADDR terrainLayer5, ecx
     INVOKE WriteCharsFromString, ADDR terrainLayer6, ecx

     ret
WriteTerrain ENDP

END
