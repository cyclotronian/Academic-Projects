                #make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=1000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=FFFEh#


#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

; add your code here
         jmp     st1 
         db     507 dup(0)

;IVT entry for 80H
         
         ;dw     t_isr0
         dw     0000
	 db      508 dup(0)
	count	equ	28h
	prev	equ	20h	;variable initialization
	curr	equ	24h
	led	equ	26h
	last	equ	30h
	flag    equ 32h
	creg 	equ 	06h
	porta 	equ 	00h
	portb 	equ 	02h
	portc	equ 	04h

;main program
          
st1:      cli 
; intialize ds, es,ss to start of RAM
          mov       ax,0200h
          mov       ds,ax
          mov       es,ax
          mov       ss,ax
          mov       sp,0FFFEH
             
          mov si,prev
          mov [si],00h
          mov [si+1],00h
                   
      mov si,count
      mov [si],00h             
                 
      mov si,flag
      mov [si],00h           
                   
	  mov si,last
	  mov [si],01h

;intialize porta, portc_upper as output, portb, portc_lower as input
          mov al,10000011b	;mode input output initialization 8255
	  out creg,al

;check switch input and display switch no.	
x1: in al, portc
	mov ah,al
	in al, portb
	and ah, 07h
 ;   mov ax,0001h
	mov [curr],ax	
	
	cmp ax,0000h
	jz x1   
	mov si,prev
	cmp ax,[si]
	jz x1


	mov si,prev
    	mov bx,[si]

	cmp bx,0001h	;check prev = door
	jnz cklast

	cmp ax,0002h	;check curr = row1
	jz incre
	      
	jmp output       
	       
cklast:	mov si,last
	cmp [si],01h
	jz output
	
	mov si,last
	mov cx,[si]
	mov dx,01h

index:  rol dx,1
	loop index
	
	cmp bx,dx
	jnz output

	ror dx,1
	cmp ax,dx
	jz decre

	jmp output

incre: 	mov [prev],ax

	mov si,count
	inc [si]

	mov ax,[si]
	mov cl, 3
	div cl
	mov [last],al
	
	cmp ah,0
	jz getled
	inc [last]
	mov si,last
	mov dx,[si]

	jmp getled
	
decre:	mov [prev],ax
	
	mov si,count
	dec [si]
                	
	mov ax,[si]
	mov cl,3
	div cl
	mov [last],al
                       
	cmp ah,0 	
	jnz p2 
	
	mov si,flag
    mov [si],01h
    jmp getled
                
p2: cmp ah,2
    jnz p1  
    
           
    mov si,flag  
    cmp [si],01h
    jnz p1
         
    mov [si],00h
    mov si,count
    inc [si]   
     
p1:	inc [last]
	jmp getled

output:	mov [prev],ax
	jmp x1
		

getled:	mov dx,1
	mov si,last
	mov cx,[si]
	mov [led],0000h

gogo:	mov si,led
	or [si],dx
	rol dx,1
	loop gogo

	mov si,led
	mov ax,[si]
	out porta,al
	rol ah,4
	and ah,30h
	mov al,ah
	out portc,al

jmp x1
;check switch input and display switch no.

