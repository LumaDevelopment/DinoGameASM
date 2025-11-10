; Sub <10ms precision delay based on the GetDateTime procedure
; (which has ~100 ns precision in theory)

INCLUDE DinoGame.inc

.data

delayStartTime   QWORD ?
delayCurrentTime QWORD ?
timeDiff         QWORD ?
delayInHundredNs QWORD ?

.code

PostTickDelay PROC USES eax ebx ecx edx,
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
PostTickDelay ENDP

END
