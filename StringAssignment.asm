.MODEL SMALL  
.STACK 100H  
.DATA  

BUFF  db  100             
db  0             
db 100 dup ('$')
BUFFL  db  100             
db  0             
db 100 dup ('$') 
BUFFC  db  100             
db  0             
db 100 dup ('$')  
   
check db 0
temp dw ? 
temp2 db ?
temp3 db ' '
count db 0   
scount db ?
STRING DB 'Enter string >  ',13,10, '$' 
CA DB 13,10,'$' 
msg2 DB 13,10, "select choic > ",0DH,0AH,"S:convert to small letter",0DH,0AH,"C:convert to capital letter",0DH,0AH,"O:convert first letter for each word to captal",,0DH,0AH,"R:reverse string ",,0DH,0AH,"W:show number of words ",,0DH,0AH,"L:show number of letter ",0DH,0AH,"$"
MSG3 DB  0DH,0AH, ' YOUR LOWER CASE STRING IS  :-----> :   $'
MSG4 DB  0DH,0AH, ' YOUR UPPER CASE STRING IS  :-----> :   $' 
MSG5 DB  0DH,0AH, ' YOUR REVERSE STRING IS  :-----> :   $' 
MSG6 DB  0DH,0AH, ' NUMBER OF WORDS IS  :-----> :   $'   
MSG7 DB  0DH,0AH, ' NUMBER OF LEETERS IS  :-----> :   $'
MSG8 DB  0DH,0AH, ' FIRST LEETER OF EACH WORD IS CAPITAL  :-----> :   $' 
MSG9 DB  0DH,0AH, ' PRESS B: TO RETURN TO THE MAIN MENU ',13,10," PRESS Q: TO EXIST FROM PROGRAM $"
.CODE  

MOV AX,@DATA  
MOV DS,AX  
 
mov ah,09h
lea dx,string
int 21h

mov ah,0Ah
lea dx,buff
int 21h    

mov ah,09h
lea dx,ca
int 21h

call main 




exist:
mov ah,4ch
int 21h





main proc 
 
mov ah,09h
lea dx,msg2
int 21h    
    
MOV AH, 08H 
INT 21H  
MOV BL,AL    
   
cmp bl,'S' ; determine the choice
je S
 
cmp bl,'C'
je C
   
cmp bl,'R'
je R

cmp bl,'W'
je W 

cmp bl,'L'
je L

cmp bl,'O'
je O 

jmp ee        

S:
call ConvertLower 
call checkCont

C:
call ConvertUpper 
call checkCont

R:
call reverse  
call checkCont

W: 
call words  
call checkCont

L: 
call letters  
call checkCont 

O: 
call firstWord  
call checkCont

ee:
call main 

ret 
endp 






checkCont proc ; B: TO RETURN TO THE MAIN MENU  
mov ah,09h     ; Q: TO EXIST FROM PROGRAM
lea dx,msg9
int 21h 


MOV AH, 08H 
INT 21H  
MOV BL,AL 
   
          
cmp bl,'Q'
je Q
 
cmp bl,'B'
je B          
    
jmp e

Q:
MOV AH,4CH
INT 21H



B:
CALL main


e:
call checkCont    
ret     
endp




ConvertLower PROC NEAR   ;convert string to lowercase

LEA SI,buff 
LEA DI,buffL


READ:

MOV BL,[si]
CMP bl,0DH
JE  DISPLA
or bl,20H 
mov [di],bl          
INC SI
inc di
JMP READ
          


DISPLA:

MOV BL,'$'
MOV [DI],BL

LEA DX,MSG3
MOV AH,09H
INT 21H


LEA DX,buffl+2
MOV AH,09H
INT 21H

RET 
ENDP 
		




ConvertUpper PROC NEAR     ;convert string to uppercase

LEA SI,buff 
LEA DI,buffC
;MOV AH,01H

READ1:

MOV BL,[si]
CMP bl,0DH
JE  DISPLA1
and BL,0DFH
mov [di],bl          
INC SI
inc di
JMP READ1
          


DISPLA1:

MOV BL,'$'
MOV [DI],BL

LEA DX,MSG4
MOV AH,09H
INT 21H


LEA DX,buffC+2
MOV AH,09H
INT 21H

RET 
ENDP 





reverse PROC NEAR     ;reverse string
    
mov ah,09h
lea dx,msg5
int 21h    

mov bl,[buff+1]
xor bh,bh
mov si,bx
mov cx,si
dec si          
mov di,si
printing:
mov dl,[buff+2+si]                                                  
cmp dl,' '
jz print_word
cmp si,0
jz last
con:
dec si                                                            
loop printing 
jmp end 
 
last:
dec si 
mov check,1
print_word:
mov bx,di
sub bx,si
mov di,si 
dec di
mov temp,si      
inc si
print:
mov dl,[buff+2+si]
mov ah,2h
int 21h
dec bx
inc si
cmp bx,0            
jnz print  
cmp check,1
jz nospace
mov dl,32
int 21h  
nospace:
mov si,temp
jmp con  
end:
ret 
endp









words PROC       ; found number of word
mov ah,09h
lea dx,msg6
int 21h
mov si,offset buff+2  
		
mov cl,buff+1         
mov dh,00               
cmpagain1: 
mov al,[si]      
cmp al,' '       
jne below        
inc dh
        
below:  
inc si              
dec cl               
jnz cmpagain1        
inc dh
mov scount,dh       
mov bl,scount
mov al,BL 
mov ah,0 
aam 
mov bx,ax 
mov ah,02h 
mov dl,bh 
add dl,48 
int 21h  
mov dl,bl 
add dl,48 
int 21h    
 
 
ret 
endp






letters PROC          ;found number of letters
mov ah,09h
lea dx,msg7
int 21h
mov si,offset buff+2  
		
mov cl,buff+1         
mov dh,00             
cmpagain11:  
mov al,[si]      
cmp al,' '        
jne below1        
inc dh
        
below1: 
inc si              
dec cl               
jnz cmpagain11      
        
mov scount,dh       
mov bl,scount
mov cl,buff+1
sub cl,scount 
        
mov al,cL 
mov ah,0 
aam 
mov bx,ax 
mov ah,02h 
mov dl,bh 
add dl,48 
int 21h  
mov dl,bl 
add dl,48 
int 21h    
  
ret 
endp




firstWord PROC       ;convert first letter in each word to capital
mov ah,09h
lea dx,MSG8
int 21h
mov si,offset buff+2 
mov al,[si]  
and al,0DFH
mov [si],al 
	
mov cl,buff+1
l1:                         
mov al,[si]
CMP al,0DH
je existf     
cmp al,' ' 
je first
inc si
loop l1

first: 
inc cl
mov al,[si+1]  
and al,0DFH
mov [si+1],al  
inc si
jmp l1


existf:
mov ah,09h
lea dx,buff+2
int 21h



ret
endp




end