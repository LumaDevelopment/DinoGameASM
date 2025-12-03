; Procedures to help calculate game score

INCLUDE DinoGame.inc

TIME_DIVISOR_FOR_SCORE = 50 ; What to divide elapsed ms by to get score

SCORE_DISPLAY_X = (TARGET_COLS / 2) - 10
SCORE_DISPLAY_Y = 15

.data

scoreStartTime DWORD ?
scoreEndTime   DWORD ?

; Score display things

scoreDisplayPrefix BYTE "Score: ",0

.code

; Methods to record when the game starts and when the 
; dino dies. Went with GetTickCount instead of 
; local/system time because the math is easier. Went 
; with GetTickCount instead of GetMseconds because it 
; resets less frequently than every day.

RecordStartTime PROC
     pushad
     INVOKE GetTickCount
     mov scoreStartTime,eax
     popad
     ret
RecordStartTime ENDP

RecordEndTime PROC
     pushad
     INVOKE GetTickCount
     mov scoreEndTime,eax
     popad
     ret
RecordEndTime ENDP

; Calculate score based on start and end time.
; Returns score in EAX.
GetScore PROC USES ebx edx
     INVOKE CalculateTickDelta, scoreStartTime, scoreEndTime
     cmp eax,0
     je EndOfProcedure ; Do not divide if EAX = 0

     ; Divide ms elapsed to get score
     mov edx,0 ; Clear upper half of dividend
     mov ebx,TIME_DIVISOR_FOR_SCORE ; Load divisor
     div ebx

     EndOfProcedure:
          ret
GetScore ENDP

DisplayScore PROC USES eax ebx ecx edx esi
     call WipeScreen

     ; eax = score, ebx = x, ecx = y, edx = indexing
     call GetScore
     mov bl,SCORE_DISPLAY_X
     mov cl,SCORE_DISPLAY_Y
     mov edx,0

     DrawPrefix:
          cmp BYTE PTR scoreDisplayPrefix[edx],0
          je FinishProcedure

          lea esi,scoreDisplayPrefix
          add esi,edx
          push eax
          INVOKE SetPixelInScreen, cl, bl, esi
          pop eax
          inc bl
          inc edx
          jmp DrawPrefix

     FinishProcedure:
          INVOKE WriteDecToScreen, cl, bl, eax
          call RenderScreen
          ret
DisplayScore ENDP

END
