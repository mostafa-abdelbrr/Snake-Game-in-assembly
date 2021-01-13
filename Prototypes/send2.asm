.model small 
  .386
  .stack 
  
  .data
;  Value db 10 DUP('$')
  InData db 30,?,30 dup('$')
  STR1 DB "ENTER YOUR STRING HERE ->$"
        STR3 DB "YOUR STRING IS ->$"
        STR2 DB 15,0,15 DUP('?')
        NEWLINE DB 10,13,"$"
  .code
  main proc far 
   mov ax,@data
   mov ds,ax
   mov ah,0
   mov al,13h
   int 10h
  




  ;Set Divisor Latch Access Bit
mov dx,3fbh ; Line Control Register
mov al,10000000b ;Set Divisor Latch Access Bit
out dx,al ;Out it

;Set LSB byte of the Baud Rate Divisor Latch register.

mov dx,3f8h
mov al,0ch
out dx,al

;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
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



   call DrawLine


        LEA SI,STR2


        MOV AH,09H
        LEA DX,STR1
        INT 21H

        MOV AH,0AH
        MOV DX,SI
        INT 21H

      MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

       ; MOV AH,09H
        ;LEA DX,STR3
        ;INT 21H

       ; MOV AH,09H
        ;LEA DX,STR2+2
        ;INT 21H


        ;MOV AH,4CH
       ; INT 21H

mov dx,3FDH   ;line status register
Again: 
in al,dx       ;read line status
test al,00100000b
Jz Again        ;Not empty
;if empty put the value in transmit data register
mov dx,3F8H     ;transmit data register
mov al, byte ptr str2+2
out dx,al
ret
main endp
DrawLine Proc
mov ah,6
mov al,1
mov bh,7
mov ch,0
mov cl,0
mov dh,12
mov dl,79
int 10h
ret
DrawLine endp

end main