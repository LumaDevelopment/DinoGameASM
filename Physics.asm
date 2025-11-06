; Procedures for sprite collisions and dino 
; jump curves

INCLUDE DinoGame.inc

; The physical representation of a given sprite.
; Used for collision calculations
BoundingBox STRUCT
     x         BYTE ?
     y         BYTE ?
     boxWidth  BYTE ?
     boxHeight BYTE ?
BoundingBox ENDS

END