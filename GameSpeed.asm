; Manages the game getting faster and faster as time goes on

INCLUDE DinoGame.inc

.data

tickLengthInMs DWORD 10
shortenTickAt  DWORD 2000,4000,6000,0FFFFFFFFh
;                    9    8    7
shortenArrIdx  DWORD 0

.code

; Get the length of the current tick in 
; milliseconds. Returns in EAX
GetTickLength PROC USES esi,
     currentTick:DWORD

     ; Check if we need to decrease tick length
     lea esi,shortenTickAt
     add esi,shortenArrIdx
     mov eax,[esi]
     cmp currentTick,eax
     jne ReturnTickLength

     DecreaseTickLength:
          ; Decrease the length of ticks from now on
          dec tickLengthInMs

          ; Increase shortenArrIdx
          mov eax,shortenArrIdx
          add eax,TYPE shortenTickAt
          mov shortenArrIdx,eax

     ReturnTickLength:
          mov eax,tickLengthInMs
          ret
GetTickLength ENDP

END
