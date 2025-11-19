; Procedures which allow each tick to occupy the same amount 
; of time, no matter how much work is done within it.

INCLUDE DinoGame.inc

.data

delayStartTime   QWORD ?
delayCurrentTime QWORD ?
timeDiff         QWORD ?
delayInHundredNs QWORD ?

.code

; This procedure, called at the top of the tick, stores 
; the time the tick started, and how long it should last. 
; That way, even if more or less work needs to be done 
; in each tick, they all last the same amount of time.
TickStartForDelay PROC USES eax ecx edx,
     delayInMs:DWORD

     ; Convert delayInMs to delayInHundredNs = delayInMs * 10,000
     mov eax,delayInMs
     mov edx,0
     mov ecx,10000
     mul ecx ; edx:eax = eax * ecx (64-bit result)

     mov DWORD PTR delayInHundredNs,eax
     mov DWORD PTR delayInHundredNs+4,edx

     ; Record start time
     INVOKE GetDateTime, ADDR delayStartTime

     ret
TickStartForDelay ENDP

; This procedure, called at the end of the tick, compares 
; the current time to the time that the tick should end, 
; and if that time has not reached, it continues to check 
; the current time until such time is reached.
DelayUntilTickEnd PROC USES eax edx
     CheckForDelayEnd:
         INVOKE GetDateTime, ADDR delayCurrentTime

         ; timeDiff = delayCurrentTime - delayStartTime
         mov eax,DWORD PTR delayCurrentTime
         mov edx,DWORD PTR delayCurrentTime+4
         sub eax,DWORD PTR delayStartTime
         sbb edx,DWORD PTR delayStartTime+4

         mov DWORD PTR timeDiff,eax
         mov DWORD PTR timeDiff+4,edx

         ; Compare timeDiff >= delayInHundredNs ?
         mov eax,DWORD PTR timeDiff
         mov edx,DWORD PTR timeDiff+4

         cmp edx,DWORD PTR delayInHundredNs+4
         jb NotYet
         ja EndOfProcedure
         cmp eax,DWORD PTR delayInHundredNs
         jb NotYet

     EndOfProcedure:
         ret

     NotYet:
         jmp CheckForDelayEnd
DelayUntilTickEnd ENDP

END
