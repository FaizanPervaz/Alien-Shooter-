
displaystring macro linetodisplay ;Printing the string and using it through the macros
mov ah,09h
mov dx,offset linetodisplay
int 21h
endm

pushall macro
   push ax
   push bx
   push cx
   push dx
endm

popall macro
   pop dx
   pop cx
   pop bx
   pop ax
endm

screenset macro p1,p2,p3,p4,attitrubetes 
	mov ah,06h
	mov al,0h
	mov bh,attitrubetes
	mov ch,p1
	mov cl,p2
	mov dh,p3
	mov dl,p4
	int 10h
endm
onscreenpoint macro row,col
	mov ah,02
	mov bh,0h
	mov dh,row
	mov dl,col
	int 10h
endm

DisplayText Macro r,c,linetodisplay ;Printing the text which is used in the menu
  pushall 
   mov ah,2
   mov bh,0
   mov dh,r
   mov dl,c
   int 10h
   mov ah,9
   mov dx,offset linetodisplay
   int 21h
   popall
ENDM DisplayText

EmptyScreen MACRO         
    mov ax,0600h  
    mov bh,07                   
    mov cx,0      
    mov dl,80     
    mov dh,25     
    int 10h    
    
    mov ax,0
    mov ah,2
    mov dx,0
    int 10h     
ENDM EmptyScreen

.MODEL SMALL
.STACK 100h    
.DATA 
   
player db 50,?,50 dup('$')
get_name db 'Input Your Good Name: ','$'
totalscore db 'The Total Score : ??','$'

d1 db ' Welcome to the Alien Shooter Game $'	
d2 db 'The Outbreak has Affected Whole Universe$'
d3 db 'Kill the Enemies to Save your Universe $'
d4 db 'Press Any Key to Continue $'
d5 db '^ $'
d6 db 'Controls are :         < + > $'
d7 db 'Are you Ready? $'
d8 db 'v $'
ins1   db '1.Your Bullets are Precious$'
ins2   db '	Dont Waste Them$'
ins3   db '2.In Start You Have 4 Bullets$'
ins4   db '	You Gain Bullets on Killing$'
ins5   db '3.You can Hover over the Plain$'
ins6   db '4.Keep Shooting to Win$'
ins7   db '4.Press Enter To Continue$'
ins8   db '4.Press Esc To Quit$'
over1  db 'Very Well Played$'
over2  db 'KO But there is always a Second Try$'
over3  db '************$'
fhandle dw 0
	buffer dw 50 dup("$")
	fname db "file.txt",0

	var1 dw 0


.CODE   
MAIN PROC  
mov ax, @DATA
mov ds, ax  
    
  EmptyScreen
  call GameStart 
  
  EmptyScreen 
  call EndGame
  
GameStart Proc ;Starting the menu procedure
	push ax
	push bx
	push cx
	push dx
	push ds 

	EmptyScreen
	screenset 0,0,24,79,15h ;in order to clear the screen
	CheckNameloop:
	DisplayText 8,8,get_name

	;Receiving the  player name from the user
	Mov ah, 3dh
	Mov al, 02h
	Mov dx, offset fname
	int 21h
	jc error1
	mov fhandle, ax
	;;;;;;;input

	mov si, offset player
	mov cx, 0

	l1:
		mov ah, 01
		int 21h

		cmp al, 13
		je outofloop

		mov [si],al

		inc si
		inc cx

	jmp l1

	outofloop:
	

	;;;;;;writing
	mov var1, cx

	Mov ah, 40h
	Mov bx, fhandle
	Mov dx, offset player
	Mov cx, var1
	int 21h
	jc error2

	;;;;;;;reading

	Mov ah, 3fh
	Mov dx, offset player
	Mov cx, lengthof player
	Mov bx, fhandle
	int 21h
	jc error3 

	error1:
		
	error2:
	error3:
	exit:

leaveloop: ;Exiting the screen after entering the name of the user
	EmptyScreen

	screenset 0,0,24,79,40h ;in order to clear the screen
	screenset 7,19,15,60,0eh
	onscreenpoint 8,21
	displaystring d1
	onscreenpoint 9,21
	displaystring d2
	onscreenpoint 10,21
	displaystring d3
	onscreenpoint 11,46
	displaystring d5
	onscreenpoint 12,21
	displaystring d6
	onscreenpoint 13,46
	displaystring d8
	onscreenpoint 14,25
    displaystring d7
	onscreenpoint 15,25
	displaystring d4

	mov ah,01h
	int 21h

    EmptyScreen 

	screenset 0,0,24,79,50h ;in order to clear the screen
	screenset 7,19,15,60,0eh
	onscreenpoint 8,21
	displaystring ins1
	onscreenpoint 9,21
	displaystring ins2
	onscreenpoint 10,21
	displaystring ins3
	onscreenpoint 11,21
	displaystring ins4
	onscreenpoint 12,21
	displaystring ins5
	onscreenpoint 13,21
	displaystring ins6
	onscreenpoint 14,25
    displaystring ins7
	onscreenpoint 15,25
	displaystring ins8

	isinpt:
	mov AH,0            		 
	int 16H 
	cmp al,13   ;Enter to go  
	JE lessgogame
	cmp ah,1H   ;Esc to not go
	JE nogogame
	JNE isinpt
	
	nogogame:
	mov ah,4CH
	int 21H

	lessgogame: 
	pop ds
	popall

	RET
GameStart ENDP

EndGame Proc 
	EmptyScreen
	screenset 0,0,24,79,15h	
	screenset 7,19,15,60,0eh
	onscreenpoint 9,21
	displaystring over1
	onscreenpoint 10,21
	displaystring over2
	onscreenpoint 11,21
	displaystring over3
	DisplayText 12,21,totalscore

;Exiting the program
mov ah,4CH
int 21H 
ret
EndGame ENDP 

main endp
end main