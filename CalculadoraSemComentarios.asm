include 'emu8086.inc'

org 100h

jmp start

     
enter db 0ah,0dh,"$"

op1 db "Adicao - a", 0x0D, 0x0A, 0x0D, 0x0A, "$"
op2 db "Subtracao - b", 0x0D, 0x0A, 0x0D, 0x0A, "$"
op3 db "Multiplicacao - c", 0x0D, 0x0A, 0x0D, 0x0A, "$"
op4 db "Divisao inteira - d", 0x0D, 0x0A, 0x0D, 0x0A, "$"
op5 db "Raiz Quadrada - e", 0x0D, 0x0A, 0x0D, 0x0A, "$"
op6 db "Cartao de Cidadao - f", 0x0D, 0x0A, 0x0D, 0x0A, "$"
op7 db "NIF - g", 0x0D, 0x0A, 0x0D, 0x0A, "$"
askEscolha db "Escolha a opcao que quer (a - g): $" 
msgErro db "Parametro invalido$"
AUX db 0


tamanhoSoma db 0  
tamanhoParc1 db 0
tamanhoParc2 db 0
limitadorSoma db 10

primeiraNegSoma db 0 
segundaNegSoma db 0

parc1 db 10 dup(0)
parc2 db 10 dup(0)  
resultadoSoma db 11 dup(0)

msgParc1 db "Digite a primeira parcela: $"
msgParc2 db "Digite a segunda parcela: $"
msgResSoma db "Soma dos numeros: $" 
msgErroSoma db "Digito invalido! Carregue qualquer tecla para sair... $" 
msgErroNegSoma db "Posicao do '-' invalida Carregue qualquer tecla para sair... $"


tamanhoMinuendo db 0
subtraMaiorMinu db 0
limitadorSubtracao db 10 
 
minuendo db 10 dup(0)
subtraendo db 10 dup(0)
resSubtracao db 10 dup(0) 

msgMinuendo db "Digite o minuendo: $"
msgSubtraendo db "Digite o subtraendo: $"
msgResSub db "Resuldado subtracao: $"
msgResSubInv db "Resuldado subtracao: -$" 
msgErroSub db "Digito invalido! pressione qualquer tecla para sair... $"



askFator1 db "Escolha o primeiro Fator: $"
askFator2 db "Escolha o segundo Fator: $" 
msgResultMul db "Resultado: $"
fatorArr1 db 10 dup (0)   
fatorArr2 db 10 dup (0) 
resultMultArr db 10 dup (0) 
resultMult dw 0  
tamanhoFator1 dw 0  
tamanhoFator2 dw 0
tamanhoMult dw 0 
carryMult dw 0 
counterMult dw 0 
multAux dw 0
curFator2 dw 0
curFator1 dw 0 
i dw 0
j dw 0
resultTotal dw 0 
tamanhoMul dw 0
convertMul dw 0 




msgtest db "TESTE: $"
askDividendo db "Escolha o dividendo: $"
askDivisor db "Escolha o divisor: $"
msgQuociente db "Quociente: $"
msgResto db "Resto: $"
divisor dw 0
divisorarray db 5 dup (0)
dividendoarray db 5 dup (0)
tamanhoDividendo db 0
tamanhoDivisor db 0
quociente dw 0  
tamanhoHO db 0
auxHO dw 0
CasaDoQuociente db 1
countConstrDiv db 0
counterAuxArr db 2
resto dw 0
HO dw 0
countDiv db 0
aux1 db 0
auxArr dw 10 dup (0)      
dividendoAux db 5 dup (0)
tamanhoaux db 0   
potenciaAux dw 0
tamanhoauxHO db 0
                        

askRaiz db "Introduza um valor: $" 
resultRaiz db "Resultado: $"
msgVirgula db ",$" 
arrRaiz db 10 dup (0)
raizReal dw 0
resultReal dw 0   
flagVirgula db 0 
tamanhoRaizInteiro dw 0     
tamanhoRaizReal dw 0  
currentParNum dw 0 
resultadoRaiz dw 0 
maiorPot dw 0 
currentPar dw 0
raizAux dw 0 
raizCalc dw 0 
lstResultadoRaiz dw 0
tamanhoResultReal dw 0
                  

msgValido db "O numero que introduziu e valido. $" 
askCC db "Introduza o CC : $" 
msgInvalido db "O numero que introduziu nao e valido. $"
CCArr db 12 dup (0)
CCArrNovo db 12 dup (0)
soma dw 0  
soma2 dw 0
onze db 0  
dez dw 0
tamanhoCC db 0


askNIF db "Insira o NIF : $"
NIFArr db 9 dup (0)
tamanhoNIF db 0
somaNIF dw 0




start:    
    call clearScreen


    mov dx, offset op1
    mov ah, 9
    int 21h

    mov dx, offset op2
    int 21h

    mov dx, offset op3
    int 21h

    mov dx, offset op4
    int 21h       
    
    mov dx, offset op5
    int 21h
                                                     
    mov dx, offset op6
    int 21h

    mov dx, offset op7
    int 21h
    

    mov dx, offset askEscolha
    int 21h
                                     
      
validacaoNum:  
                
                
                
                                     

    mov ah, 00h     
    int 16h          

      
    cmp al, 97     
    jb erro          
    cmp al, 103    
    ja erro             

    cmp al, 97      
    je adicao      

    cmp al, 98      
    je Subt       

    cmp al, 99     
    je Mult        

    cmp al, 100   
    je divInteira  

    cmp al, 101     
    je raiz         
       
    cmp al, 102   
    je cc          

    cmp al, 103      
    je nif          
   
          
    
erro:
    pusha          
    mov ah, 0x00  
    mov al, 0x03     
    int 0x10
    popa
    
    lea dx, msgErro    
    mov ah, 09h
    int 21h 
      
    lea dx,enter        
    mov ah,09h
    int 21h 
    jmp start


adicao:

    
    call clearScreen   
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di 

    
    mov si, offset parc1    
    
    
    lea dx, msgParc1    
    mov ah , 09h
    int 21h
    call lerParc1   
    call clearScreen   
    mov tamanhoParc1,cl     
    
 
    xor cl,cl       
    mov di, offset parc2   
    lea dx, msgParc2    
    mov ah , 09h
    int 21h
    call lerParc2  
    call clearScreen    
    
    
    cmp cl, tamanhoParc1   
    jae maior   
    jb menor    
    

maior:
    mov tamanhoSoma, cl     
    jmp prepRes     
    
menor: 
     xor cl,cl 
     mov cl, tamanhoParc1  
     mov tamanhoSoma, cl    
  

prepRes:  
    xor cl,cl   
    lea dx,msgResSoma
    mov ah,09h
    int 21h
    
    dec si 
    dec di  
    mov bx, offset resultadoSoma    
    
    mov ch,primeiraNegSoma 
    cmp ch,segundaNegSoma  
    je somar    
    
   
    
    
lerParc1:   
    
    cmp cl, limitadorSoma 
    je backSoma    
    mov ah, 01h     
    int 21h 
    cmp al,13   
    je backSoma    
    cmp al,45   
    je parc1neg     
    cmp al,48   
    jb erroSoma     
    cmp al,57  
    ja erroSoma     
   
    sub al,48   
    mov [si],al 
    inc si      
    inc cl      
    jmp lerParc1  
    
lerParc2:   
    
    cmp cl, limitadorSoma 
    je backSoma     
    mov ah, 01h   
    int 21h
    cmp al,13   
    je backSoma     
    cmp al,45   
    je parc2neg    
    cmp al,48   
    jb erroSoma     
    cmp al,57   
    ja erroSoma     
    
    sub al,48   
    mov [di],al     
    inc di     
    inc cl      
    jmp lerParc2  


backSoma:
    ret    
    
parc1neg:
    cmp cl,0    
    jne erroNegativo    
    inc primeiraNegSoma     
    jmp lerParc1 
    
parc2neg:
    cmp cl,0    
    jne erroNegativo   
    inc segundaNegSoma 
    jmp lerParc2    
    

erroNegativo:
    call clearScreen   
    xor ax,ax  
    lea dx,msgErroNegSoma 
    mov ah,09h
    int 21h
    mov ah,01h  
    int 21h
    int 20h    
    
erroSoma:
    call clearScreen    
    xor ax,ax
    lea dx,msgErroSoma  
    mov ah,09h
    int 21h
    mov ah,01h  
    int 21h
    int 20h  

    
somar:    
    cmp cl,tamanhoSoma     
    je finalizar    
    xor ax,ax  
    mov al,[si]    
    add al,[di]     
    cmp al,10       
    jae carry       
    add al,[bx]     
    mov [bx],al     
    dec si          
    dec di          
    inc bx          
    inc cl       
    jmp somar     

carry:
    sub al, 0Ah    
    add [bx],al     
    dec si         
    dec di          
    inc bx        
    inc cl         
    add [bx],1      
    jmp somar      
    
mov [di],al     
inc di     
inc cl      
jmp lerParc2  


backSoma:
ret    

parc1neg:
cmp cl,0    
jne erroNegativo    
inc primeiraNegSoma     
jmp lerParc1 

parc2neg:
cmp cl,0    
jne erroNegativo   
inc segundaNegSoma 
jmp lerParc2    


erroNegativo:
call clearScreen   
xor ax,ax  
lea dx,msgErroNegSoma 
mov ah,09h
int 21h
mov ah,01h  
int 21h
int 20h    

erroSoma:
call clearScreen    
xor ax,ax
lea dx,msgErroSoma  
mov ah,09h
int 21h
mov ah,01h  
int 21h
int 20h  


somar:    
cmp cl,tamanhoSoma     
je finalizar    
xor ax,ax  
mov al,[si]    
add al,[di]     
cmp al,10       
jae carry       
add al,[bx]     
mov [bx],al     
dec si          
dec di          
inc bx          
inc cl       
jmp somar     

carry:
sub al, 0Ah    
add [bx],al     
dec si         
dec di          
inc bx        
inc cl         
add [bx],1      
jmp somar      


inc cl          
jmp dipsResSub  


fimSubt:
int 20h

Mult:

call clearScreen
xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
mov si, offset fatorArr1 
mov dx, offset askFator1 
mov ah, 09h
int 21h


validarFator1:
    inc cl          
    jmp dipsResSub  


fimSubt:
    int 20h

Mult:
    
    call clearScreen
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    mov si, offset fatorArr1 
    mov dx, offset askFator1 
    mov ah, 09h
    int 21h
    
    
validarFator1:

    mov ah, 01h
    int 21h

    cmp al,13
    je Fator2
    cmp al,48
    je check0na1pos1Mul
    cmp al,49
    jb erroMul
    cmp al,57
    ja erroMul
    jmp lerFator1
                                                           
                                                           
lerFator1: 
    sub al, 48
    mov [si],al
    inc cx
    mov tamanhoFator1, cx
    inc si
    jmp validarFator1  

       
       
erroMul:
    pusha          
    mov ah, 0x00  
    mov al, 0x03
    int 0x10
    popa
    
    lea dx, msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter
    mov ah,09h
    int 21h
    jmp Mult
    
    
    
check0na1pos1Mul:
    cmp tamanhoFator1, 0
    je erroMul
    jmp lerFator1 
    
    
Fator2:
    call clearScreen
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    mov si, offset fatorArr2
    mov dx, offset askFator2
    mov ah, 09h
    int 21h
    
 
validarFator2:

    mov ah, 01h
    int 21h

    cmp al,13
    je multCalc
    cmp al,48
    je check0na1pos1Mul2
    cmp al,49
    jb erroMul2
    cmp al,57
    ja erroMul2
    jmp lerFator2
                                                           
                                                           
lerFator2: 
    sub al, 48
    mov [si],al
    inc cx
    mov tamanhoFator2, cx
    inc si
    jmp validarFator2 
    
    
    
erroMul2:
    pusha          
    mov ah, 0x00  
    mov al, 0x03
    int 0x10
    popa
    
    lea dx, msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter
    mov ah,09h
    int 21h
    jmp Mult
    
    
    
check0na1pos1Mul2:
    cmp tamanhoFator2, 0
    je erroMul2
    jmp lerFator2 
    
            
            
            
multCalc: 
    
    mov ax, tamanhoFator1
    mov cx, tamanhoFator2
    cmp cx, ax
    jb multResets1
    jmp multResets2

    
      
 
multResets1:
    mov si, offset fatorArr2
    mov ax, tamanhoFator2
    dec ax
    add si,ax
    mov j,1



multCalc1: 
    mov di, offset fatorArr1
    mov counterMult,0
    mov carryMult,0
    mov multAux,1
    mov resultMult,0
    mov al, [si]
    mov curFator2, ax 
    mov cx, tamanhoFator1 
    dec cx  
    add di, cx
    inc cx
    call getMultCalc1 
    mov ax,resultMult 
    mov bx,j
    mul bx
    add resultTotal,ax
    mov ax,j
    mov dx,10
    mul dx
    mov j,ax
    add i,1
    dec si
    mov ax, tamanhoFator2
    call getMaiorTamanho 
    mov tamanhoMul, bx
    cmp i, ax
    jae endMul
    jmp multCalc1
    
    
    
getMultCalc1:
    cmp counterMult,cx
    je extraCarry1
    mov ax, curFator2
    mov bl, [di]
    mul bx
    add ax, carryMult
    cmp ax, 10
    jae carryMult1 
    mov bx,10
    div bx
    dec di 
    mov ax,multAux
    mul dx
    add resultMult, ax 
    mov ax,multAux
    mov bx,10
    mul bx
    mov multAux,ax
    add counterMult, 1 
    mov carryMult,0
    cmp counterMult, cx
    jb getMultCalc1
    ret
    

carryMult1:
    mov bx,10
    div bx
    mov carryMult, ax
    mov ax,multAux
    mul dx
    add resultMult, ax
    mov ax,multAux
    mov bx,10
    mul bx
    mov multAux,ax 
    dec di 
    add counterMult, 1
    cmp counterMult, cx
    jb getMultCalc1
    cmp carryMult, 0
    jne getMultCalc1 
    ret 

extraCarry1:
    mov ax, carryMult
    mov dx,multAux
    mul dx
    add resultMult, ax
    mov ax, resultMult
    add counterMult, 1
    ret  
 
 
 
 
 
multResets2:
    mov si, offset fatorArr1
    mov ax, tamanhoFator1
    dec ax
    add si,ax
    mov j,1
 

multCalc2:
    mov di, offset fatorArr2
    mov counterMult,0
    mov carryMult,0
    mov multAux,1
    mov resultMult,0
    mov al, [si]
    mov curFator1, ax 
    mov cx, tamanhoFator2 
    dec cx  
    add di, cx
    inc cx
    call getMultCalc2 
    mov ax,resultMult 
    mov bx,j
    mul bx
    add resultTotal,ax
    mov ax,j
    mov dx,10
    mul dx
    mov j,ax
    add i,1
    dec si
    mov ax, tamanhoFator1
    call getMaiorTamanho 
    mov tamanhoMul, bx
    cmp i, ax
    jae endMul
    jmp multCalc2
    
    
    
getMultCalc2:
    cmp counterMult,cx
    je extraCarry2
    mov ax, curFator1
    mov bl, [di]
    mul bx
    add ax, carryMult
    cmp ax, 10
    jae carryMult2 
    mov bx,10
    div bx
    dec di 
    mov ax,multAux
    mul dx
    add resultMult, ax 
    mov ax,multAux
    mov bx,10
    mul bx
    mov multAux,ax
    add counterMult, 1 
    mov carryMult,0
    cmp counterMult, cx
    jb getMultCalc2
    ret
    

carryMult2:
    mov bx,10
    div bx
    mov carryMult, ax
    mov ax,multAux
    mul dx
    add resultMult, ax
    mov ax,multAux
    mov bx,10
    mul bx
    mov multAux,ax 
    dec di 
    add counterMult, 1
    cmp counterMult, cx
    jb getMultCalc2
    cmp carryMult, 0
    jne getMultCalc2 
    ret 

extraCarry2:
    mov ax, carryMult
    mov dx,multAux
    mul dx
    add resultMult, ax
    mov ax, resultMult
    add counterMult, 1
    ret  
       
       
       
getMaiorTamanho:
    mov bx,tamanhoMul
    mov cx,counterMult
    cmp bx,cx
    jb maiorTamanho
    ret
    
    
maiorTamanho:
    mov bx,cx
    ret
    


endMul: 
    call clearScreen
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx

    
    mov ah, 01h      
    int 21h
       
    
    mov dx, offset msgResultMul
    mov ah, 9
    int 21h  
      
    mov cx, tamanhoMul
    mov ax,1
    call converte_e_mostraMul 
    
    
    mov ah, 01h      
    int 21h
    
    jmp start 
    
    
converte_e_mostraMul:
    mov dx,1
    xor bx,bx 
    cmp tamanhoMul,0
    je converte_loopMulLast
    
    mov bx,10
    mul bx
    mov dx,ax
    inc ch
    cmp ch,cl
    mov bx,1
    mov convertMul, dx
    je converte_loopMul
    jmp converte_e_mostraMul 
    
    
converte_loopMul:
    mov ax,convertMul
    mul bx        
    inc bx
    cmp ax,resultTotal
    jb converte_loopMul
    sub bx,2
    xor ax,ax
    mov al,bl
    add al, '0'      
   
    mov ah, 14
    int 10h            
    mov dx,convertMul
    xor ah,ah
    sub al,48
    sub tamanhoMul,1
    mov cx, tamanhoMul
    mul dx 
    sub resultTotal,ax
    mov ax,1 
    cmp tamanhoMul,65535
    je backMul
    cmp tamanhoMul,0
    jae converte_e_mostraMul 
    
    
converte_loopMulLast:
    xor ax,ax
    mov ax,resultTotal
    add al, '0'        
    
    mov ah, 14
    int 10h            
    
       
                              
backMul:
    ret 
    
             
erroDiv:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        
    int 0x10
    popa
    
    lea dx, msgErro     
    mov ah, 09h
    int 21h 
      
    lea dx,enter       
    mov ah,09h
    int 21h
    jmp divInteira 
     
Primeiroif:               
        
         mov ax, HO
         mov auxHO, ax                  
         call atribuirDoisDigitosArray  
         
         mov dl, counterAuxArr          
         cmp dl, tamanhoHO 
         jne Primeiroif                 
         
         mov counterAuxArr, 1           
         mov si, OFFSET dividendoarray  
                         
         mov HO,0                       
         mov ax, 1                      


divInteira:
    xor cl,cl 
    call clearScreen
    mov dx, offset askDividendo
    mov ah, 09h
    int 21h
    xor si, si
    lea si,dividendoarray


validarDividendo:

    mov ah, 01h
    int 21h

    cmp al,13
    je continuar
    cmp al,48
    je check0na1pos1
    cmp al,49
    jb erroDiv
    cmp al,57
    ja erroDiv
    jmp lerDividendo


lerDividendo: 
    sub al, 48
    mov [si],al
    inc cl
    mov tamanhoDividendo, cl
    inc si
    cmp cl,4
    ja continuar
    jmp validarDividendo  

    
check0na1pos1:
    cmp tamanhoDividendo, 0
    je erroDiv
    jmp lerDividendo
    
check0na1pos12:
    cmp tamanhoDivisor, 0
    je erroDiv2
    jmp lerDivisor
    
continuar:

    cmp tamanhoDividendo, 0
    je erroDiv   

    lea dx,enter
    mov ah,09h
    int 21h                              
    lea dx,enter
    mov ah,09h
    int 21h
    
    xor di, di
    lea di,divisorarray
    
        
    xor cx,cx
    
    jmp pedirDivisor     
               
               
pedirDivisor:

    mov dx, offset askDivisor
    mov ah, 09h
    int 21h
    
    jmp validarDivisor
               
validarDivisor:

    mov ah, 01h
    int 21h

    cmp al,13
    je continuar2
    cmp al,48
    je check0na1pos12
    cmp al,49
    jb erroDiv2
    cmp al,57
    ja erroDiv2
    jmp lerDivisor


lerDivisor:   
    sub al, 48
    mov [di],al
    inc cl
    mov tamanhoDivisor, cl
    inc di
    cmp cl,4
    ja continuar2
    jmp validarDivisor  
    
erroDiv2:

    pusha          
    mov ah, 0x00  
    mov al, 0x03
    int 0x10
    popa
    
    lea dx, msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter
    mov ah,09h
    int 21h
    jmp pedirDivisor   
    
    
    
continuar2:

    cmp tamanhoDivisor, 0
    je erroDiv2    

    lea dx,enter
    mov ah,09h
    int 21h                              
    lea dx,enter
    mov ah,09h
    int 21h
    
    jmp divisao

divisao:
    mov quociente , 0
    mov resto , 0
    mov HO , 0
    
    xor bx,bx
    mov si, OFFSET divisorarray
    mov bl , 1
    mov ax ,1
    mul tamanhoDivisor 
    dec ax
    mov countConstrDiv, al                    
    add si,ax
    xor cx,cx
    xor ax,ax
    mov cx, 1
    jmp ConstrDiv
    
ConstrDiv:             
         
    mov bl, [si]
    
    mov ax, cx
    mul bx
                               
    add divisor, ax
                               
    mov bx, 10
    mov ax, cx
    mul bx
    mov cx, ax
    
    cmp countConstrDiv ,0
    je PreConstrAuxArr
    
    dec si
    dec countConstrDiv
                           
    jmp ConstrDiv
    
PreConstrAuxArr:
    mov si, OFFSET auxArr
    add si, 2
    mov ax, divisor
    mov [si] , ax
    add si, 2

    jmp ConstrAuxArr

ConstrAuxArr:

    add ax,divisor
    mov [si] , ax
    
    inc counterAuxArr
    mov bl,counterAuxArr 
    cmp bl, 10
    je iniciarDivisao
    
    inc si
    inc si 
     
    jmp ConstrAuxArr
    

iniciarDivisao:
    xor ax,ax
    xor cx,cx
    mov si, OFFSET dividendoarray
    mov al, [si]
    mov bl , tamanhoDividendo
    mov tamanhoaux, bl
    
    xor bx,bx
              
    mov HO, ax
    mov tamanhoHO, 1
                            
    mov CasaDoQuociente, 1
    
    jmp verificardivaux

verificardivaux:
    cmp tamanhoaux , 0
    je finalDiv

    jmp proximaIteracao

proximaIteracao:
    xor ax,ax 
    mov si, OFFSET auxArr
    call calcularMenorAux
    dec bl
    
    mov si, OFFSET dividendoarray
    
    cmp bl,0
    jne Primeiroif
        
    jmp continuarNormal 
        
HONotZeroSegundaParteIf:

    mov counterAuxArr, 0
    mov si, OFFSET dividendoarray
    cmp cx,0
        jne Primeiroif
        
        jmp continuarNormal

    Primeiroif:               
        
         mov ax, HO
         mov auxHO, ax                  
         call atribuirDoisDigitosArray  
         
         mov dl, counterAuxArr          
         cmp dl, tamanhoHO 
         jne Primeiroif                 
         
         mov counterAuxArr, 1           
         mov si, OFFSET dividendoarray  
                         
         mov HO,0                       
         mov ax, 1                      
         call atribuirDoisDigitosHO     
         
         jmp continuarNormal            

    atribuirDoisDigitosArray:
        
        mov ax, auxHO                   
        div potenciaAux                 
         
        mov [si], ax                    
        mov auxHO, ax                   
        
        mov ax, potenciaAux
        mov dx, 10
        div dx                          
        mov potenciaAux, ax
        
        inc dl                          
        inc si                          
        inc tamanhoaux                          
        
        cmp dl,tamanhoauxHO             
        jne inserirDigitosNoArray               
        
        ret

    atribuirDoisDigitosHO:
        
        mov dx, [si]                    
        mov auxHO, dx
        mul auxHO                       
        
        add HO, ax                      
        
        inc counterAuxArr
        mov ax, 10                      
        
        cmp counterAuxArr, 2            
        jne atribuirDoisDigitosHO        
        
        ret                             
        
    continuarNormal:
        
        cmp cx,0
        je CXZeroSegundaParteIf
        
        jmp continuarNormal1
        
    CXZeroSegundaParteIf:
        cmp tamanhoaux, 0
        jne SegundoIf
        
        jmp continuarNormal1  

    SegundoIf:                  

        mov ax, HO
        mov auxHO, ax                   
        
        mov al, tamanhoHO
        mov tamanhoauxHO, al    
        
        mov si, OFFSET dividendoarray   
        mov ax, 10                      
        mul HO                          
        dec si
        call concatenarHO
        
        mov si, OFFSET dividendoarray   
        xor dx,dx                       
        mov ax,1                          
        call potencia                   
        xor dx,dx                       
        mov dh,tamanhoauxHO             
        call inserirDigitosNoArray      
        
        jmp continuarNormal1            

    concatenarHO:
        inc si                          
        
        cmp [si],0                       
        je concatenarHO

        add al, [si]                    
        mov HO, ax                      
        inc tamanhoHO                   
        
        ret
        
    inserirDigitosNoArray:
        
        mov ax, auxHO                   
        xor dx,dx
        div potenciaAux                 
         
        mov [si], al                    
        mov auxHO, ax                   
        
        mov ax, potenciaAux
        mov di, 10
        div di                          
        mov potenciaAux, ax
        
        inc cl                          
        inc si                          
        inc tamanhoaux
        
        cmp cl,tamanhoauxHO             
        jne inserirDigitosNoArray               
        
        ret

    potencia:
        
        mov bx, 10
        mul bx       
        
        cmp dh,dl
        jne potencia 
        
        div bx
        mov potenciaAux, ax
        
        ret    
                  
                                     
    continuarNormal1:
        
        cmp HO,0
        je HOZeroSegundaParteIf
        
        jmp continuarNormal2

    HOZeroSegundaParteIf:

        mov si, OFFSET dividendoarray      
        dec si                             
        
        cmp tamanhoaux, 0
        jne TerceiroIf
        
        jmp continuarNormal2
        
    TerceiroIf:                

        inc si             
        
        cmp [si] , 0
        je TerceiroIf      
        
        mov dx, [si]
        mov HO, dx         
        mov tamanhoHO, 1
        
        jmp continuarNormal2   
        

    continuarNormal2:

        jmp verificardivaux    

    calcularMenorAux:
        
        mov cx, ax          
        mov ax, [SI]        
        add si, 2           
        
        mov bl,bh           
        inc bh              
        
        mov dx, HO          
        cmp ax, dx          
        jna calcularMenorAux 
        
        ret                 

    finalDiv:
        mov ax, HO          
        mov resto, ax  

        xor cl, cl          

        mov si,0
        lea si,dividendoarray 

        mov AX, 03h
        int 10h 
        
        lea dx, msgQuociente    
        mov ah, 09h
        int 21h
        
        xor ah, ah              
        mov ax,quociente 
        Call print_num_uns

        lea dx,enter            
        mov ah,09h
        int 21h
        
        lea dx, msgResto        
        mov ah, 09h
        int 21h     
        
        xor ah,ah               
        mov ax,resto 
        Call print_num_uns      
        
        mov ah, 00h             
        int 16h                 
        
        int 20h

    raiz:   
        call clearScreen   
        
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
        xor si,si
        xor di,di   
        
        mov tamanhoRaizInteiro, 0
        mov tamanhoRaizReal, 0
        
        mov si, offset arrRaiz
        
        mov dx, offset askRaiz
        mov ah, 9
        int 21h    
        
        validarRaiz:

        mov ah, 01h      
        int 21h          

        cmp al,13            
        je checkNumAlg         
        cmp al,48            
        je check0na1pos1Raiz     
        cmp al,44            
        je virgula           
        cmp al,49            
        jb erroRaiz           
        cmp al,57            
        ja erroRaiz           
        cmp flagVirgula,1
        je  lerRaizReal
        jmp lerRaizInteiro      
        
        
    lerRaizInteiro:   
        sub al, 48
        mov [si],al  
        inc cl  
        mov tamanhoRaizInteiro, cx   
        inc si  
        jmp validarRaiz   
        
        
    lerRaizReal:   
        sub al, 48
        mul bl
        xor ah,ah
        add raizReal,ax
        inc cl  
        mov tamanhoRaizReal, cx   
        inc di  
        sub bl, 9
        cmp tamanhoRaizReal,2
        je checkNumAlg
        jmp validarRaiz   
          
          

    check0na1pos1Raiz:
        cmp tamanhoRaizInteiro, 0   
        je erroRaiz                  
        jmp lerRaizInteiro


        
    virgula:
        cmp flagVirgula, 1
        je erroRaiz
        mov flagVirgula, 1
        xor cx,cx 
        mov bl, 10
        jmp validarRaiz  
        
        
    erroRaiz:
        pusha          
        mov ah, 0x00  
        mov al, 0x03        
        int 0x10
        popa
        
        lea dx, msgErro     
        mov ah, 09h
        int 21h 
          
        lea dx,enter        
        mov ah,09h
        int 21h
        jmp raiz   
        
               
       
              
    checkNumAlg:
        xor ax,ax
        mov ax,tamanhoRaizInteiro
        mov bx,2
        div bl
        cmp ah,1
        je resets 
        jmp resets2   
        
    resets:
        mov si, offset arrRaiz 
        xor ax,ax
        mov cx,tamanhoRaizInteiro
           

    construirArrImpar: 
        xor bx,bx
        mov bl,[si]
        xor bh,bh
        mov [si],al 
        mov ax,bx   
        cmp cl, ch
        je resets2  
        inc si 
        inc ch
        jmp construirArrImpar
        
    resets2:
    mov si, offset arrRaiz
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
                       
    
raizCalculoInteiroP1: 
   
    
    call getParAlgInteiro
    xor ax,ax
    xor cx,cx
    mov cl,1
    call getMaiorPot
    mov bx, currentPar
    sub bx, maiorPot
    mov ax, 100
    mul bx 
    mov raizAux, ax
    cmp tamanhoRaizInteiro,2
    jbe raizCalculoReal
    jmp raizCalculoInteiroP2    
    
    
    
raizCalculoInteiroP2:
    mov si, offset arrRaiz 
    mov dx, currentParNum
    mov ax, 2
    mul dx
    cmp ax, tamanhoRaizInteiro
    jae resets3
    call getParAlgInteiro
    mov ax,raizAux
    add ax, currentPar
    mov raizAux, ax 
    mov cx, 1
    call getRaizCalcInteiro
    mov ax,raizAux
    sub ax, raizCalc
    mov bx,100
    mul bx
    mov raizAux,ax
    jmp raizCalculoInteiroP2
               

    
    
getParAlgInteiro:
    mov ax, currentParNum
    mov bx,2
    mul bx
    add si,ax
    mov al,[si]
    mov bx,10
    mul bx
    inc si
    mov bl,[si]
    add ax,bx
    mov bx, currentParNum
    inc bx
    mov currentParNum, bx 
    mov currentPar, ax
    ret      
         
         
    
getMaiorPot:
    mov ax,cx
    mul cx   
    inc cx
    cmp ax,currentPar
    jbe getMaiorPot
    sub cx,2
    mov resultadoRaiz, cx
    mov lstResultadoRaiz, cx
    add tamanhoResultReal,1
    mov ax,cx
    mul ax
    mov maiorPot, ax
    ret 
           
           
getRaizCalcInteiro:
    mov ax,2
    mul resultadoRaiz 
    mov bx,10
    mul bx
    mov raizCalc,ax 
    call getRaizCalcInteiro2
    mov lstResultadoRaiz,cx
    add tamanhoResultReal,1
    mov ax,10
    mul resultadoRaiz
    add ax, lstResultadoRaiz
    mov resultadoRaiz,ax
    ret  
             

getRaizCalcInteiro2:
    add raizCalc,1
    mov ax,raizCalc
    mul cx  
    inc cx
    cmp ax,raizAux
    jbe getRaizCalcInteiro2
    sub cx,2
    sub raizCalc,1
    mov ax,raizCalc
    mul cx
    mov raizCalc,ax
    ret  
           
           
resets3:
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx 
            
    
            
raizCalculoReal:
    cmp raizAux,0
    je endRaiz
    mov ax,raizAux
    add ax, raizReal
    mov raizAux, ax 
    mov cx, 1
    call getRaizCalcReal
    jmp endRaiz
    
        
        
getRaizCalcReal:
    mov ax,2
    mul resultadoRaiz 
    mov bx,10
    mul bx
    mov raizCalc,ax 
    call getRaizCalcReal2 
    ret  
             

getRaizCalcReal2:
    add raizCalc,1
    mov ax,raizCalc
    mul cx  
    inc cx
    cmp ax,raizAux
    jbe getRaizCalcReal2
    sub cx,2
    sub raizCalc,1
    mov resultReal,cx
    ret
    
 
endRaiz:
    call clearScreen   
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx

    
    
       
    mov dx, offset resultRaiz 
        mov ah, 9
        int 21h  
        
        sub tamanhoResultReal,1   
        mov cx, tamanhoResultReal
        mov ax,1
        call converte_e_mostra 
        
        mov dx, offset msgVirgula
        mov ah, 9
        int 21h
        
        
        mov ax,resultReal
        xor ah,ah
        add al, '0'        
        mov ah, 14
        int 10h            
        
        
        
        
        mov ah, 01h      
        int 21h
        
        jmp start 
        
        
    converte_e_mostra:
        mov dx,1
        cmp tamanhoResultReal,0
        je converte_loop
        mov bx,10
        mul bx
        mov dx,ax
        inc ch
        cmp ch,cl
        je converte_loop
        jmp converte_e_mostra 
        
        
    converte_loop:
        mov ax,resultadoRaiz
        div dl
        add al, '0'        
        mov ah, 14
        int 10h            
        xor ah,ah
        sub al,48
        sub tamanhoResultReal,1
        mov cx, tamanhoResultReal
        mul dl 
        sub resultadoRaiz,ax
        mov ax,1 
        cmp tamanhoResultReal,65535
        je back
        cmp tamanhoResultReal,0
        jae converte_e_mostra
        
        
    back:
        ret

    cc:
        call clearScreen     
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
        xor si,si
        xor di,di
        
        mov tamanhoCC, 0 
        
        mov si, offset CCArr

        mov dx, offset askCC
        mov ah, 9
        int 21h   
        

     

    validarCC1Parte:
        mov cl, tamanhoCC
        cmp cl, 8
        je teste
        mov ah, 01h      
        int 21h          

        cmp al,48            
        je check0na1pos1CC     
        cmp al,49            
        jb erroCC           
        cmp al,57            
        ja erroCC         
        xor bl, bl
        xor ch, ch
        mov bl, 10

        call lerCC
        jmp validarCC1Parte

    erroCC:
        pusha          
        mov ah, 0x00  
        mov al, 0x03        
        int 0x10
        popa
        
        lea dx, msgErro     
        mov ah, 09h
        int 21h 
          
        lea dx,enter        
        mov ah,09h
        int 21h
        sub cl,1
        jmp cc

    check0na1pos1CC:
        cmp tamanhoCC, 0   
        je erroCC                 
        call lerCC  
        jmp validarCC1Parte

    lerCC: 
        xor dx,dx
        xor cx,cx
        xor ah,ah 
        sub al,48
        mov [si],al 
        add tamanhoCC, 1  
        inc si  
        mov dl, al
        mov cl, 2
        mov al, tamanhoCC
        div cl
        cmp ah, 1
        je soma2calc
        add soma2, dx
        ret      
        
    soma2calc:
        
        mov al, dl
        mul cl 
        cmp ax, 10
        jae maiorque10
        add soma2, ax 
        ret    
        
    maiorque10:
        sub ax, 9
        add soma2, ax
        ret
        
        
          
    teste:     
        mov si, offset CCArr
        mov soma, 0
        xor cx,cx 
        xor dx,dx 
        xor ax,ax 

    checkDigit1: 
        xor ax,ax 
        dec bl                 
        mov al, bl              
        mov dl, [si]
        inc si            
        mul dl                  
        add soma, ax                    
        inc cx                  
        cmp bl, 2               
        je checkDigit1div  
        jmp checkDigit1
        

    checkDigit1div:
        xor ax,ax
        xor bx,bx
        xor cx,cx
        mov ah, 01h      
        int 21h          
        cmp al, 48
        jb checkDigit1div
        cmp al, 57
        ja checkDigit1div   
        mov bl,al  
        sub bl,48 
        call lerCC
        mov cl, bl
        mov ax, soma 
        mov bl, 11
        div bl
        cmp ah,0
        je checkDigit1igual0
        cmp ah,1
        je checkDigit1igual0
        sub bl,ah
        jmp checkDigit1dif0

    checkDigit1igual0:

        cmp cl,0
        je versao
        jmp errado

    checkDigit1dif0:

        cmp cl,bl
        je versao
        jmp errado


    errado:   
        call clearScreen
        lea dx, msgInvalido     
        mov ah, 09h
        int 21h
        mov ah, 01h      
        int 21h          
        jmp cc

    versao: 
        mov cl, tamanhoCC
        mov si, offset CCArr
        add si, cx       
        cmp cx, 11
        je checkDigit2
        mov ah, 01h      
        int 21h          
                
        cmp al, 48
        jb errover 
        cmp al,90           
        jg errover         
        cmp al,57            
        jbe versaoNumeros           
        cmp al,65
        jae versaoLetras
        jmp errover

    errover:
        pusha          
        mov ah, 0x00  
        mov al, 0x03        
        int 0x10
        popa
        
        lea dx, msgErro     
        mov ah, 09h
        int 21h 
          
        lea dx,enter        
        mov ah,09h
        int 21h
        sub cl,1
        jmp cc  
        
     
    versaoNumeros:   
        mov cl, tamanhoCC
        mov si, cx
        call lerCC
        jmp versao 
        
    versaoLetras:
        sub al, 7  
        mov cl, tamanhoCC
        mov si, cx
        call lerCC   
        jmp versao


    checkDigit2:
        mov ah, 01h      
        int 21h          
        cmp al,49            
        jb erroCD2           
        cmp al,57            
        ja erroCD2           
        call lerCC  
        
        jmp checkDigit2div

    erroCD2:
        pusha          
        mov ah, 0x00  
        mov al, 0x03        
        int 0x10
        popa
        
        lea dx, msgErro     
        mov ah, 09h
        int 21h 
          
        lea dx,enter        
        mov ah,09h
        int 21h
        sub cl,1
        jmp cc


    checkDigit2div:
        xor cx, cx
        mov cl, dl 
        mov ax, soma2
        xor dx,dx
        xor bx,bx 
        mov bx, 10
        div bx
        cmp dx,0
        je CCFim
        jmp invalido

    invalido:
        call clearScreen
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
        mov dx, offset msgInvalido     
        mov ah, 9
        int 21h 
        mov ah, 01h      
        int 21h          
        jmp cc


    CCFim:
        call clearScreen 
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx         
        mov dx, offset msgValido     
        mov ah, 9h
        int 21h    
        xor ax,ax
        mov ah, 01h      
        int 21h          
        jmp start
        
    nif: 

        call clearScreen
              
        xor ax,ax
        xor bx,bx
        xor cx,cx
        xor dx,dx
        xor si,si
        xor di,di
        
        mov si, offset NIFArr
        
        mov dx, offset askNIF
        mov ah, 9
        int 21h


    validarInput:  
        mov cl, tamanhoNIF 
        cmp cl,9
        je validarNIF
        mov ah, 01h      
        int 21h          

        cmp al,48            
        je check0na1posNIF     
        cmp al,49            
        jb erroNIF           
        cmp al,57            
        ja erroNIF           
        call lerNIF     
        jmp validarInput
        
        
    lerNIF: 
        sub al,48
        mov [si],al 
        inc cl  
        mov tamanhoNIF, cl  
        inc si  
        cmp cl,9 
        ret


    check0na1posNIF:
        cmp tamanhoNIF, 0   
        je erroNIF                  
        call lerNIF
        jmp validarInput


    erroNIF:
        pusha          
        mov ah, 0x00  
        mov al, 0x03        
        int 0x10
        popa
        
        lea dx, msgErro     
        mov ah, 09h
        int 21h 
          
        lea dx,enter        
        mov ah,09h
        int 21h
        sub cl,1
        jmp validarInput
              
              
              
    validarNIF:
        
        mov si, offset NIFArr 
        xor cx,cx 
        xor ax,ax

        mov bx,9  
        
    validarNIF_new: 

        mov ax, [si]
        xor ah,ah
        mul bx
        inc cx
        inc si
        dec bx   
        add somaNIF, ax 
        
        cmp cx, 8
        je validarNIF2
        jmp validarNIF_new

    validarNIF2:

        xor dx,dx
        xor bx,bx
        mov bx, 11
        mov ax, somaNIF
        div bx
        cmp dx, 0
        je NIF0
        jmp NIFdif0


    NIF0:
        mov si, offset NIFArr
        add si, 8 
        cmp [si], 0
        je NIFValido
        jmp NIFInvalido

    NIFdif0:
        mov si, offset NIFArr   
        xor ax,ax
        mov ax,11
        add si,8
        sub ax, dx
        mov dx, [si]   
        xor dh, dh
        cmp ax, dx
        je NIFValido
        jmp NIFInvalido

    NIFInvalido:
        call clearScreen
        xor ax,ax
        xor dx,dx
        lea dx, msgInvalido     
        mov ah, 09h
        int 21h
        mov ah,00h          
        int 16h
        jmp NIF

    NIFValido:
        call clearScreen
        xor ax,ax
        xor dx,dx
        lea dx, msgValido     
        mov ah, 09h
        int 21h 
        xor ax,ax
        mov ah,00h
        int 16h
        xor ax,ax
        xor bx,bx
        xor cx,cx 
        jmp start



    DEFINE_PRINT_NUM_UNS


    clearScreen:
        mov AX, 03h
        int 10h 
        ret

    int 20h ; Terminar o programa
           
    end start
