; Procedures to help calculate game score

INCLUDE DinoGame.inc

TIME_DIVISOR_FOR_SCORE = 50 ; What to divide elapsed ms by to get score

.data

startTime DWORD ?
endTime   DWORD ?

.code

; Methods to record when the game starts and when the 
; dino dies. Went with GetTickCount instead of 
; local/system time because the math is easier. Went 
; with GetTickCount instead of GetMseconds because it 
; resets less frequently than every day.

RecordStartTime PROC
     pushad
     INVOKE GetTickCount
     mov startTime,eax
     popad
     ret
RecordStartTime ENDP

RecordEndTime PROC
     pushad
     INVOKE GetTickCount
     mov endTime,eax
     popad
     ret
RecordEndTime ENDP

; Calculate score based on start and end time.
; Returns score in EAX.
GetScore PROC USES ebx edx
     INVOKE CalculateTickDelta, startTime, endTime
     cmp eax,0
     je EndOfProcedure ; Do not divide if EAX = 0

     ; Divide ms elapsed to get score
     mov edx,0 ; Clear upper half of dividend
     mov ebx,TIME_DIVISOR_FOR_SCORE ; Load divisor
     div ebx

     EndOfProcedure:
          ret
GetScore ENDP

END
