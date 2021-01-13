.model small
.386
.stack 64
.data
;me db 16,0,15 DUP('$')
me db ?
me_row db 0
me_col db 5
them db ?
them_col db 5
them_row db 12

.code
main proc far
mov ax,@data
mov ds,ax
mov ax,03h
int 10h
begin:

mov ah,2
mov dh,me_row
mov dl,me_col
int 10h

mov ah,06h
mov dl,0ffh
int 21h
;mov ah,1
;int 21h
mov cx,1000
jnz saveandsend
jz receive

saveandsend:
mov me,al
cmp me,0Dh
jnz continuechecks
inc me_row
mov me_col,4
continuechecks:
mov ah,2
mov dl,me
int 21h
call setup
mov dx,3FDH   ;line status register
Again: 
in al,dx       ;read line status
test al,00100000b
Jz Again        ;Not empty
inc me_col
cmp me_col,80
jnz continuesend
mov me_col,5
inc me_row
cmp me_row,12
js continuesend
mov ah,07h
mov al,00h
mov bh,0fh
mov cx,0
mov dl,80
mov dh,12
int 10h ; scroll chat window
;mov me_row,0
;mov me_col,5
continuesend:
;if empty put the value in transmit data register
mov dx,3F8H     ;transmit data register
mov al,me
out dx,al

mov cx,1000
receive:
call setup
;Checking data is ready
mov dx,3FDH ;line status register
check: in al,dx
cmp cx,0
jz begin
dec cx
test al,1
jz check ;not ready
;if ready ,read the value in receive data register 
mov dx ,03f8h
in al,dx
mov them,al

inc them_col
cmp them_col,80
jnz continuerec
mov them_col,5
inc them_row
cmp them_row,25
jnz continuerec
mov them_row,12
mov ah,07h
mov al,0
mov bh,0fh
mov cx,1200
mov dl,80
mov dh,25
int 10h ; scroll chat window


cmp them,0Dh
jnz continuerec
inc them_row
mov them_col,4
continuerec:

mov ah,2
mov dh,them_row
mov dl,them_col
int 10h

       ; MOV AH,09H
        ;LEA DX,them
        ;INT 21H
mov ah,02h
mov dl,them
int 21h



jmp begin
main endp

setup proc

 ;Set Divisor Latch Access Bit
mov dx,3fbh ; Line Control Register
mov al,10000000b ;Set Divisor Latch Access Bit
out dx,al ;Out it

;Set LSB byte of the Baud Rate Divisor Latch register.

mov dx,3f8h
mov al,1h
out dx,al

;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,0h
out dx,al
;Set port configuration
mov dx,3fbh
mov al,00011011b
;0:Access to Receiver buffer, Transmitter buffer
;0:Set Break disabled
;011:Even Parity
;0:One Stop Bit
;11:8bits
out dx,al
ret
setup endp

end main