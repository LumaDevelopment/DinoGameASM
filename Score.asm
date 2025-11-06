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

END
