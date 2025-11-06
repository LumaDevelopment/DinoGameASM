; Procedures to help calculate game score

INCLUDE DinoGame.inc

.data

startTime DWORD ?
endTime   DWORD ?

.code

; Methods to record when the game starts and when the 
; dino dies. Went with GetTickCount instead of 
; local/system time because the math is easier. Went 
; with GetTickCount instead of GetMseconds because it 
; resets less frequently than every day.

RecordStartTime PROC USES eax
     INVOKE GetTickCount
     mov startTime,eax
     ret
RecordStartTime ENDP

RecordEndTime PROC USES eax
     INVOKE GetTickCount
     mov endTime,eax
     ret
RecordEndTime ENDP

; Calculate score based on start and end time.
; Returns score in EAX.
GetScore PROC USES ebx edx
     mov eax,endTime
     cmp startTime,eax
     ; If startTime > endTime, then tick counter reset
     ; to 0 while the user was playing, making 
     ; calculations more complex
     ja ComplexCalc

     SimpleCalc:
          ; Calculate difference between start and end time
          mov eax,endTime
          sub eax,startTime

          ; Divide ms elapsed by 10 to get score
          mov edx,0  ; Clear upper half of dividend
          mov ebx,10 ; Load divisor
          div ebx
     ComplexCalc:
     ret
GetScore ENDP

END
