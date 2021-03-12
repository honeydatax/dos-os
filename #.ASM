;starts
nop

mov ax,cs
mov bx,1000h
cmp ax,bx
jz escapes
jmp exitss
escapes:


mov ax,ss
mov bx,offset ffars
mov cs:[bx],ax


mov ax,sp
mov bx,offset ffarip
mov cs:[bx],ax

mov ax,3
int 10h

;set vector 21h local call      
        push cs
        pop ds
        mov al,21h
        mov dx,offset aint21
call vector

        
        ;set vector 20h by int 21h
        push cs
        pop ds
        mov ah,25h
        mov al,20h
        mov dx,offset aint20 
int 21h

        mov ax,9000h
        mov es,ax
        mov ax,19
mov cx,4

call loader




restart:
mov ax,cs
mov es,ax
mov ds,ax

mov bx,offset ffars
mov ax,cs:[bx]
mov dx,ax

mov bx,offset ffarip
mov ax,cs:[bx]
mov sp,ax
mov ss,dx


call cls

mov ah,2
mov dx,101h
        mov bh,0
        int 10h

       mov ah,9h
mov dx,offset gmsg
int 21h
 
myloop:

mov ax,cs
mov es,ax
mov ds,ax
       mov ah,9h
mov dx,offset mmsg
int 21h


mov bx,offset commandline
mov al,16
mov ax,cs
mov ds,ax
mov ds:[bx],al
mov dx,bx

mov ah,0ah

int 21h
      mov ah,9h
mov dx,offset enterline
int 21h


mov bx,offset commandline + 2
call len

        mov ax,9000h
        mov es,ax

mov bx,100h
mov dx,offset commandline + 2

@mloop:
call COMPSTR
cmp ax,cx
ja @mloop1
add bx,32
cmp bx,896
jb @mloop  
jmp myloop

@mloop1:

        add bx,1ah
        mov dx,es:[bx]
        add dx,31
mov ax,cs
mov bx,1000h
add ax,bx
mov es,ax
mov ax,dx
mov cx,30

call loader


mov ax,es
mov ds,ax
mov bx,offset ffar
mov ax,100h
mov cs:[bx],ax
inc bx
inc bx
mov ax,ds
mov cs:[bx],ax
dec bx
dec bx

jmp  far dword cs:[bx]

jmp restart

        xor ah,ah
int 21h

@llop2:
call check
cmp al,0
jz @llop2
        

@myloop3:
call check
cmp al,0
jnz @myloop3




        xor ah,ah
int 21h



check:
        in al,60h
        and al,128
        ret



aint21 db  90h
cmp ah,0
jnz esc0
jmp aaint20
esc0:
cmp ah,25h
jnz esc1
jmp aavector
esc1:
cmp ah,1h
jnz esc2
jmp aainput
esc2:
cmp ah,2h
jnz esc3
jmp aaoutput
esc3:
cmp ah,9h
jnz esc4
jmp aawrite
esc4:
cmp ah,0ah
jnz esc5
jmp aaiinput
esc5:
cmp ah,4ch
jnz esc6
jmp aaint20
esc6:
iret 


aaiinput:
        push dx
        push cx
        push bx
        push ax
        push si
        push di
push bp
mov cl,0
mov bx,dx
mov ch,ds:[bx]
inc bx
mov si,bx
aaiinput2:
mov ah,1
int 21h
mov dl,al
inc bx
inc cl
mov ds:[bx],dl
cmp cl,0
jz aaiinput3
cmp cl,ch
jz aaiinput3
cmp dl,13
jnz aaiinput2

aaiinput3:
mov ds:[si],cl

inc bx
mov al,0
mov ds:[bx],al

pop bp
        pop di
        pop si
        pop ax
        pop bx
        pop cx
        pop dx

iret 


 

aainput:
        push dx
        push cx
        push bx
        push bp
        push si
        push di

        xor ah,ah
int 16h
push ax
mov bx,offset ccart
mov [bx],al

mov ah,3

        mov bh,0
        int 10h

        mov bp,offset ccart
        
        mov bl,41h
        mov ah,13h
        mov al,1
        mov bh,0
        mov cx,1
int 10h
pop ax

pop di
pop si
pop bp
        pop bx
        pop cx
        pop dx

iret 


aaoutput:
        push dx
        push cx
        push bx
        push ax
push di
push si
push bp

mov bx,offset ccart2
mov [bx],al

mov ah,3

        mov bh,0
        int 10h

        mov bp,offset ccart
        
        mov bl,41h
        mov ah,13h
        mov al,1
        mov bh,0
        mov cx,1
int 10h
pop bp
pop si
pop di
        pop ax
        pop bx
        pop cx
        pop dx

iret 



aawrite:
        push dx
        push cx
        push bx
        push ax
push si
push di
push bp
push ds
push es
push cs

pop es
mov si,dx
aawrite1:
mov al,ds:[si]
cmp al,'$'
jz aawrite2
mov bx,offset ccart2
mov cs:[bx],al

mov ah,3

        mov bh,0
        int 10h

        mov bp,offset ccart2
        
        mov bl,41h
        mov ah,13h
        mov al,1
        mov bh,0
        mov cx,1
int 10h
 inc si
jmp aawrite1
aawrite2:

pop es
pop ds
pop  bp
pop di
pop si
        pop ax
        pop bx
        pop cx
        pop dx

iret 




avector db  90h
aavector:
call vector
iret 

vector:
        push es
        push bp
        push dx
        push cx
        push bx
        push ax

        xor ah,ah
        push dx
        xor dx,dx
        xor cx,cx
        mov es,cx
        mov bx,4
        imul bx
        mov bp,ax
        pop ax
        mov es:[bp],ax
        mov ax,ds
        inc bp
        inc bp
        mov es:[bp],ax
        
        pop ax
        pop bx
        pop cx
        pop dx 
        pop bp
        pop es
        ret



aint20 db 90h 
aaint20:        
jmp restart
iret

cls:
mov dl,0
mov dh,0
for1:
        
        mov cx,1
        mov bp,offset msg
mov bl,41h
push dx

call prints

pop dx
inc dl
cmp dl,79
jnz for2
mov dl,0
inc dh
for2:

cmp dh,25
jnz for1

ret


prints:
        mov bl,41h
        mov ah,13h
        mov al,0
        mov bh,0

int 10h
ret

LEN:                
          push bx                
          push cx                
          push dx                
          mov cx,0                
          LEN1:                
                    mov al,cs:[bx]
                    cmp al,0                
                    JZ LEN2                
                    inc bx                
                    inc cx                
                    cmp cx,0                
                    JNZ LEN1                
          LEN2:                
          mov ax,cx
          pop dx                
          pop cx                
          pop bx                
          RET              

COMPSTR:                
          push bx                
          push cx                
          push dx                
          push di                
          push si                
          mov cx,0                
          mov si,bx
          mov di,dx
          COMPSTR1:
                    mov al,es:[si]
                    mov ah,cs:[di]
                    cmp al,0                
                    JZ COMPSTR2
                    cmp ah,0                
                    JZ COMPSTR2
                     cmp al,13               
                    JZ COMPSTR2
                    cmp ah,13         
                    JZ COMPSTR2
                     cmp al,32           
                    JZ COMPSTR2
                    cmp ah,32
                    JZ COMPSTR2
                    cmp al,ah
                    JNZ COMPSTR2
                    inc di                
                    inc si                
                    inc cx                
                    cmp cx,0                
                    JNZ COMPSTR1
          COMPSTR2:
          mov ax,cx
          pop si                
          pop di                
          pop dx                
          pop cx                
          pop bx                
          RET                
                



   loader:
        push bp
        push dx
        push cx
        push bx
        push ax
        push si
        push di

push cx
        xor dx,dx
        xor cx,cx
        mov bx,36
        clc
        idiv bx
        push ax
        mov ax,dx

        xor dx,dx
        xor cx,cx
        mov bx,18
        clc
        idiv bx
        push ax
        mov ax,dx
        inc dx
        mov cl,dl
        pop ax
        mov dh,al
        pop ax
        mov ch,al
        
        
        

        
        mov bx,100h
       pop ax
        
        mov ah,2
        mov dl,0

int 13h
        
pop di
pop si
        pop ax
        pop bx
        pop cx
        pop dx
        pop bp
        ret

             


exitss:
mov ax,4c00h
int 21h


msg db "  "

ccart db "     "
ccart2 db "     "
ffars dq 0,0,0,0,0,0
ffarip dq 0,0,0,0,0,0

ffar dq 0,0,0,0
commandline db "                                                                 $",0
enterline db 13,10,'$',0
mmsg db "mini dos.>$",0
gmsg db "commad list : EXIT  DIR",13,10,"$",0
xhhh db "  CLS LS CLEAR MEM LABEL COMMAND DRIVE CALC TIME KEY ASCII LOTO GUESS BALL" ,13,10,"$",0
