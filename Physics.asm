; Procedures for sprite collisions and dino 
; jump curves

INCLUDE DinoGame.inc

.code

; Determines if two bounding boxes are colliding.
; Algorithm stolen from:
; https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection#axis-aligned_bounding_box
; Returns: BL = 1 if colliding, 0 otherwise
AreBoundingBoxesColliding PROC,
     boxOne:BoundingBox,
     boxTwo:BoundingBox

     ; boxOne.Position.X < boxTwo.Position.X + boxTwo.BoxWidth
     ; boxOne.Position.X + boxOne.BoxWidth > boxTwo.Position.X
     ; boxOne.Position.Y < boxTwo.Position.Y + boxTwo.BoxHeight
     ; boxOne.Position.Y + boxOne.BoxHeight > boxTwo.Position.Y

     ret
AreBoundingBoxesColliding ENDP

END