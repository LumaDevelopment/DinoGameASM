; chrome://dino, adapted to Assembly
; Built for a console with 30 rows and 120 columns

INCLUDE Irvine32.inc

.data
rows BYTE ?
cols BYTE ?

.code
main proc
	call GetMaxXY
	mov  rows, al
	mov  cols, dl

	exit
main endp
end main