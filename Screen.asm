; Maintains an array that represents the current state of the
; screen. Allows for the terrain, obstacles, and dino to be 
; written to memory, then all of it can be rendered at once.

INCLUDE DinoGame.inc

ROW_SIZE = TARGET_COLS + 2 ; space for CRLF
BUFFER_SIZE = TARGET_ROWS * ROW_SIZE

.data
screenBuffer BYTE BUFFER_SIZE DUP(?)
blankRow     BYTE TARGET_COLS DUP(' ')

.code

; Sets the last two bytes of every row in 
; screenBuffer to 0dh,0ah. None of the other 
; procedures in this file should affect the 
; last two bytes of every row, so we should 
; never have to do this again
InitScreen PROC USES eax ecx
     mov ecx,TARGET_ROWS
     mov eax,OFFSET screenBuffer
     add eax,TARGET_COLS ; Point to first CRLF position

     InitRow:
          mov BYTE PTR [eax],0dh
          mov BYTE PTR [eax+1],0ah
          add eax,ROW_SIZE
          loop InitRow

      ret
InitScreen ENDP

; Plucks TARGET_COLS bytes from the given text and sets 
; the row at the given index to those bytes.
; THIS PROCEDURE DOES NOT CHECK FOR STRING LENGTH
SetRowInScreen PROC USES eax ecx edi esi,
     rowIndex:BYTE,   ; Unsigned int representing the index of the row to set
     rowText:PTR BYTE ; Pointer to the string 

     ; Calculate offset
     movzx eax,rowIndex
     imul  eax,ROW_SIZE

     ; Move bytes from rowText to eax pos
     cld
     mov esi,rowText
     lea edi,screenBuffer[eax]
     mov ecx,TARGET_COLS
     rep movsb

     ret
SetRowInScreen ENDP

; Replaces the row at the given index with spaces
WipeRowInScreen PROC USES eax ecx edi esi,
     rowIndex:BYTE ; Unsigned int representing the index of the row to wipe

     INVOKE SetRowInScreen, rowIndex, OFFSET blankRow

     ret
WipeRowInScreen ENDP

; PROC - SetPixelInScreen
; PROC - RenderScreen

END