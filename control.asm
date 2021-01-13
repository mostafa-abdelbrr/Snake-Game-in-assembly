.model small
.386
.stack 64
.data

me_control db ?
them_control db ?

.code
main proc far
mov ax,@data
mov ds,ax
mov ax,03h
int 10h
begin:


mov ah,06h
mov dl,0ffh
int 21h
;mov ah,1
;int 21h
mov cx,1000
jnz saveandsend
jz receive

saveandsend:
mov me_control,al
call setup
mov dx,3FDH   ;line status register
Again: 
in al,dx       ;read line status
test al,00100000b
Jz Again        ;Not empty
continuesend:
;if empty put the value in transmit data register
mov dx,3F8H     ;transmit data register
mov al,me_control
out dx,al

;---- put desired behaviour here ----

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
mov them_control,al


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