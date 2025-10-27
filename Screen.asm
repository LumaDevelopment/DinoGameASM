; Maintains an array that represents the current state of the
; screen. Allows for the terrain, obstacles, and dino to be 
; written to memory, then all of it can be rendered at once.

INCLUDE DinoGame.inc

ROW_SIZE = TARGET_COLS + 2 ; space for CRLF
BUFFER_SIZE = TARGET_ROWS * ROW_SIZE

.data
screenBuffer BYTE BUFFER_SIZE DUP(?)
             BYTE 0 ; null-terminator
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
WipeRowInScreen PROC,
     rowIndex:BYTE ; Unsigned int representing the index of the row to wipe

     INVOKE SetRowInScreen, rowIndex, OFFSET blankRow

     ret
WipeRowInScreen ENDP

; Sets the pixel at the given row and column to 
; the character at the location of the given 
; pointer. Will be used for drawing the dino 
; and obstacles.
SetPixelInScreen PROC USES eax ebx esi,
     rowIndex:BYTE,
     colIndex:BYTE,
     charPointer:PTR BYTE ; Pointer to the byte to set at the given pixel in the screen

     ; Calculate offset in screen buffer
     movzx eax,rowIndex
     imul  eax,ROW_SIZE
     movzx ebx,colIndex ; avoid sign-extension
     add   eax,ebx

     ; Write 1 byte from charPointer into screenBuffer[eax]
     mov esi,charPointer
     mov bl,[esi] ; Already reserved EBX for offset calculation
     mov screenBuffer[eax],bl

     ret
SetPixelInScreen ENDP

RenderScreen PROC USES edx
     ; Write entire buffer to screen!
     mov edx, OFFSET screenBuffer
     call WriteString
     ret
RenderScreen ENDP

END
