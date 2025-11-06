; Procedures to help calculate game score

INCLUDE DinoGame.inc

TIME_DIVISOR = 50 ; What to divide elapsed ms by to get score

.data

startTime DWORD ?
endTime   DWORD ?

.code

; Methods to record when the game starts and when the 
; dino dies. Went with GetTickCount instead of 
; local/system time because the math is easier. Went 
; with GetTickCount instead of GetMseconds because it 
; resets less frequently than every day.

RecordStartTime PROC USES eax edx
     INVOKE GetTickCount
     mov startTime,eax
     ret
RecordStartTime ENDP

RecordEndTime PROC USES eax edx
     INVOKE GetTickCount
     mov endTime,eax
     ret
RecordEndTime ENDP

; Calculate score based on start and end time.
; Returns score in EAX.
GetScore PROC USES ebx edx
     mov eax,startTime
     cmp eax,endTime

     ; If startTime > endTime, then tick counter reset
     ; to 0 while the user was playing, making 
     ; calculations more complex
     ja ComplexCalc

     ; startTime should not equal end time, but just 
     ; in case
     je EdgeCase

     SimpleCalc:
          ; Calculate difference between start and end time
          mov eax,endTime
          sub eax,startTime

          ; Divide ms elapsed to get score
          mov edx,0  ; Clear upper half of dividend
          mov ebx,TIME_DIVISOR ; Load divisor
          div ebx

          jmp EndOfProcedure
     ComplexCalc:
          ; Get distance between start time and max
          mov eax,0FFFFFFFFh
          sub eax,startTime

          ; Add end time to get total elapsed time
          add eax,endTime

          ; Divide ms elapsed to get score
          mov edx,0 ; Clear upper half of dividend
          mov ebx,TIME_DIVISOR ; Load divisor
          div ebx

          jmp EndOfProcedure
     EdgeCase:
          mov eax,0 ; Score = 0
     EndOfProcedure:
          ret
GetScore ENDP

END
