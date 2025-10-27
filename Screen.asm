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

; PROC - WipeRowInScreen
; PROC - SetRowInScreen
; PROC - SetPixelInScreen
; PROC - RenderScreen

END