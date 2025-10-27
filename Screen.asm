; Maintains an array that represents the current state of the
; screen. Allows for the terrain, obstacles, and dino to be 
; written to memory, then all of it can be rendered at once.

INCLUDE DinoGame.inc

ROW_SIZE = TARGET_COLS + 2 ; space for CRLF
BUFFER_SIZE = TARGET_ROWS * ROW_SIZE

.data
screenBuffer BYTE BUFFER_SIZE DUP(?)
blankRow     BYTE TARGET_COLS DUP(' '),0dh,0ah

.code

WipeRowInScreen PROC USES eax ecx edi esi,
     rowIndex:BYTE ; Unsigned int representing the index of the row to wipe

     ; Calculate offset
     movzx eax,rowIndex
     imul  eax,ROW_SIZE

     ; Move bytes from blankRow pos to eax pos
     cld
     mov esi,OFFSET blankRow
     lea edi,screenBuffer[eax]
     mov ecx,ROW_SIZE
     rep movsb

     ret
WipeRowInScreen ENDP

; PROC - WipeRowInScreen
; PROC - SetRowInScreen
; PROC - SetPixelInScreen
; PROC - RenderScreen

END