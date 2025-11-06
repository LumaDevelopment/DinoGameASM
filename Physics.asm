; Procedures for sprite collisions and dino 
; jump curves

INCLUDE DinoGame.inc

.code

; Determines if two bounding boxes are colliding.
; Algorithm stolen from:
; https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection#axis-aligned_bounding_box
; Returns: BL = 1 if colliding, 0 otherwise
AreBoundingBoxesColliding PROC USES eax,
     boxOne:BoundingBox,
     boxTwo:BoundingBox

     ; boxOne.Position.X < boxTwo.Position.X + boxTwo.BoxWidth
     mov al,boxTwo.Position.X
     add al,boxTwo.BoxWidth
     cmp boxOne.Position.X,al
     jae NotColliding

     ; boxOne.Position.X + boxOne.BoxWidth > boxTwo.Position.X
     mov al,boxOne.Position.X
     add al,boxOne.BoxWidth
     cmp al,boxTwo.Position.X
     jbe NotColliding

     ; boxOne.Position.Y < boxTwo.Position.Y + boxTwo.BoxHeight
     mov al,boxTwo.Position.Y
     add al,boxTwo.BoxHeight
     cmp boxOne.Position.Y,al
     jae NotColliding

     ; boxOne.Position.Y + boxOne.BoxHeight > boxTwo.Position.Y
     mov al,boxOne.Position.Y
     add al,boxOne.BoxHeight
     cmp al,boxTwo.Position.Y
     jbe NotColliding

     IsColliding:
          mov bl,1
          jmp EndOfProcedure
     NotColliding:
          mov bl,0
     EndOfProcedure:
          ret
AreBoundingBoxesColliding ENDP

END