; Sub <10ms precision delay based on the GetDateTime procedure
; (which has ~100 ns precision in theory)

INCLUDE DinoGame.inc

.data

delayStartTime   DWORD ?
storedDelayInMs  DWORD ?

.code

; Increase timer resolution to 1ms
; From:
; - https://learn.microsoft.com/en-us/windows/win32/api/_multimedia/
; - https://learn.microsoft.com/en-us/windows/win32/api/timeapi/nf-timeapi-timebeginperiod
IncreaseTimerResolution PROC
     pushad
     push 1
     call timeBeginPeriod@4
     popad
     ret
IncreaseTimerResolution ENDP

; This procedure, called at the top of the tick, stores 
; the time the tick started, and how long it should last. 
; That way, even if more or less work needs to be done 
; in each tick, they all last the same amount of time.
TickStartForDelay PROC USES eax,
     delayInMs:DWORD

     ; Store delayInMs
     mov eax,delayInMs
     mov storedDelayInMs,eax

     ; Record start time
     pushad
     INVOKE GetTickCount
     mov delayStartTime,eax
     popad

     ret
TickStartForDelay ENDP

; This procedure, called at the end of the tick, compares 
; the current time to the time that the tick should end, 
; and if that time has not reached, it continues to check 
; the current time until such time is reached.
DelayUntilTickEnd PROC
     ProcedureBody:
          pushad
          INVOKE GetTickCount
          INVOKE CalculateTickDelta, delayStartTime, eax

          ; If tick delta > storedDelayInMs, jump to EndOfProcedure
          cmp eax, storedDelayInMs
          ja EndOfProcedure

          ; Now eax has end time - start time, so we need to
          ; sleep from storedDelayInMs - eax
          mov ebx,eax
          mov eax,storedDelayInMs
          sub eax,ebx

          ; Procedure used by Irvine Delay proc under the hood
          INVOKE Sleep,eax

     EndOfProcedure:
          popad
          ret
DelayUntilTickEnd ENDP

END
