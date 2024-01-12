                                                                           
                                                                                                            include 'emu8086.inc'

org 100h


jmp start

;Menu       
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

; Adicao
;tamanho das parcelas
tamanhoSoma db 0  
tamanhoParc1 db 0
tamanhoParc2 db 0
limitadorSoma db 10
;sinais de cada parc
primeiraNegSoma db 0 
segundaNegSoma db 0
;parcelas e resultado
parc1 db 10 dup(0)
parc2 db 10 dup(0)  
resultadoSoma db 11 dup(0)
;msgs
msgParc1 db "Digite a primeira parcela: $"
msgParc2 db "Digite a segunda parcela: $"
msgResSoma db "Soma dos numeros: $" 
msgErroSoma db "Digito invalido! Carregue qualquer tecla para sair... $" 
msgErroNegSoma db "Posicao do '-' invalida Carregue qualquer tecla para sair... $"



; Divisao:
msgtest db "TESTE: $"
askDividendo db "Escolha o dividendo: $"
askDivisor db "Escolha o divisor: $"
msgQuociente db "Quociente: $"
msgResto db "Resto: $"
divisor dw 0
divisorarray db 5 dup (0)
dividendoarray db 5 dup (0)
arrAux db 5 dup 0
tamanhoDividendo db 0
tamanhoDivisor db 0
quociente db 0
resto db 0
HO db 0
countDiv db 0
aux1 db 0
auxArr dw 10 dup (0)        ;Esta merda nao funciona, tou farto dessa porcaria 
dividendoAux db 5 dup (0)
tamanhoaux db 0
                        
;Raiz
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
                  
                        
;CC  
askCC db "Introduza o CC : $" 
msgInvalido db "O numero que introduziu nao e valido"
msgValido db "O numero que introduziu e valido"
CCArr db 12 dup (0)
CCArrNovo db 12 dup (0)
soma dw 0  
soma2 dw 0
onze db 0  
dez dw 0
tamanhoCC db 0

; NIF
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
                
                
                
                                     
    ; Recebendo a entrada do usuario
    mov ah, 00h      ; Servio para receber um caractere do teclado
    int 16h          ; Captura o caractere digitado

    ; O caracter digitado estara em AL, agora voce pode comparar para saber qual opcao foi escolhida   
    cmp al, 97      ; Verifica se outro caracter abaixo do 'a' na tabela ascii foi precionado
    jb erro               ; Se sim, pule para a funcao erro
    cmp al, 103     ; Verifica se outro caracter acima do 'e' na tabela ascii foi precionado
    ja erro               ; Se sim, pule para a funcao erro

    cmp al, 97      
    je adicao       ;jump para a adiçao caso a opção escolhida seja "a"  (97 em ascii)

    cmp al, 98      
    je Subt         ;jump para a adiçao caso a opção escolhida seja "b"  (98 em ascii)

    cmp al, 99     
    je Mult         ;jump para a adiçao caso a opção escolhida seja "c"  (99 em ascii)

    cmp al, 100   
    je divInteira   ;jump para a adiçao caso a opção escolhida seja "d"  (100 em ascii)

    cmp al, 101     
    je raiz         ;jump para a adiçao caso a opção escolhida seja "e" (100 em ascii)
       
    cmp al, 102   
    je cc           ;jump para a adiçao caso a opção escolhida seja "f" (102 em ascii) 

    cmp al, 103      
    je nif          ;jump para a adiçao caso a opção escolhida seja "g" (103 em ascii)
   
          
    
erro:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        ;Text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;Imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
    mov ah,09h
    int 21h 
    jmp start

;-------------------------------------------------------------------------------------------------------------------- 
adicao:

    ; primeiro array
    xor cl,cl
    mov si, offset parc1
    
    lea dx, msgParc1
    mov ah , 09h
    int 21h
    
    call lerParc1
    call clearScreen
    mov tamanhoParc1,cl
    
    ; segundo array
    xor cl,cl
    mov di, offset parc2
    lea dx, msgParc2
    mov ah , 09h
    int 21h
    call lerParc2
    call clearScreen
    
    ;prep resultado
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
    ;pedir input
    cmp cl, limitadorSoma
    je backSoma ;retorna se chegou ao tamanho
    mov ah, 01h
    int 21h
    cmp al,13 ;checkar enter
    je backSoma
    cmp al,45 ;checkar negativo
    je parc1neg
    cmp al,48 ;checkar menor que 0
    jb erroSoma
    cmp al,57 ;checkar maior que 9
    ja erroSoma
    ;se passou por todas as checkagens, adiciona ao array
    sub al,48 
    mov [si],al
    inc si 
    inc cl
    jmp lerParc1  
    
lerParc2:   
    ;pedir input
    cmp cl, limitadorSoma
    je backSoma ;retorna se chegou ao tamanho
    mov ah, 01h
    int 21h
    cmp al,13 ;checkar enter
    je backSoma
    cmp al,45 ;checkar negativo
    je parc2neg
    cmp al,48 ;checkar menor que 0
    jb erroSoma
    cmp al,57 ;checkar maior que 9
    ja erroSoma
    ;se passou por todas as checkagens, adiciona ao array
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
    

dispRes:
    cmp cl,tamanhoSoma
    ja backbackSoma
    mov al,[bx]
    add al,48
    mov ah, 0Eh
    int 10h
    dec bx
    inc cl
    jmp dispRes
    
finalizar:
    xor cl,cl
    xor ax,ax
    mov cl,primeiraNegSoma
    cmp cl,1
    je finalizarNeg
    xor cl,cl
    call dispRes
    jmp fimSoma

finalizarNeg:
    xor cl,cl
    mov al,45
    mov ah,0Eh 
    int 10h
    xor ax,ax
    call dispRes     

    
    
fimSoma:
    int 20h
    
;-------------------------------------------------------------------------------------------------------------------
Subt:
    call clearScreen
;-------------------------------------------------------------------------------------------------------------------
Mult:
    call clearScreen
;-------------------------------------------------------------------------------------------------------------------              
erroDiv:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        ;text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
    mov ah,09h
    int 21h
    jmp divInteira 
     

divInteira:
    xor cl,cl 
    call clearScreen
    mov dx, offset askDividendo ; Carrega no dx o endereco da frase para pedir o dividendo  
    mov ah, 09h     ; Funcao para imprimir string
    int 21h         ; Chamar a interrupcao do DOS para imprimir
    xor si, si
    
   
             

validarDividendo:

    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,13            ;Se encontra enter
    je continuar         ;Da je para continuar
    cmp al,48            ;Se encontra 0
    je check0na1pos1     ;Da je para CHECK0na1pos1
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroDiv           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroDiv           ;Da jump para erro se for maior que 57
    jmp lerDividendo     ;Da jump para funcao lerNumerador
    
    
lerDividendo: 
    sub al, 48
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    inc cl  ; incrementa o tamanho do Dividendo
    mov tamanhoDividendo, cl  ;atualiza o tamanho do dividendo
    inc si  ; incrementa o pointer do array para selecionar as posicoes
    cmp cl,4 ; compara se o valor do Dividendo tem 5 algorismos, conta 0,1,2,3,4 
    ja continuar
    jmp validarDividendo  

    
check0na1pos1:
    cmp tamanhoDividendo, 0   ;compara o tamanho do dividendo com 0
    je erroDiv                  ;se for igual a zero da erro
    jmp lerDividendo
    
check0na1pos12:
    cmp tamanhoDivisor, 0     ;compara o tamanho do divisor com 0
    je erroDiv2                 ;se for igual a zero da erro
    jmp lerDivisor
    
continuar:

    cmp tamanhoDividendo, 0   ;compara o tamanho do dividendo com 0 (caso de dividendo ser vazio)
    je erroDiv                  ;se for igual a zero da erro   

    lea dx,enter      ;faz um enter    
    mov ah,09h
    int 21h                              
    lea dx,enter      ;faz outro enter    
    mov ah,09h
    int 21h     
    
    xor di, di
    lea di,divisorarray ;carrega o array
    
        
    xor cx,cx
    
    jmp pedirDivisor     
               
               
pedirDivisor:

    mov dx, offset askDivisor ; Carrega no dx o endereco da frase para pedir o dividendo  
    mov ah, 09h     ; Funcao para imprimir string
    int 21h         ; Chamar a interrupção do DOS para imprimir
    
    jmp validarDivisor
               
validarDivisor:

    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,13            ;Se encontra enter
    je continuar2        ;Da je para continuar
    cmp al,48            ;Se encontra 0
    je check0na1pos12    ;Da je para CHECK0na1pos1
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroDiv2              ;da jump para erro se for menor que 49
    cmp al,57            ;
    ja erroDiv2              ;Da jump para erro se for maior que 57
    jmp lerDivisor     ;Da jump para funcao lerDivisor


lerDivisor:   
    sub al, 48
    mov [di],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    inc cl  ; incrementa o tamanho do numerador
    mov tamanhoDivisor, cl   ;atualiza o tamanho do divisor
    inc di  ; incrementa o pointer do array para selecionar as posicoes
    cmp cl,4 ; compara se o valor do numerador tem 5 algorismos, conta 0,1,2,3,4 
    ja continuar2
    jmp validarDivisor  
    
erroDiv2:

    pusha          
    mov ah, 0x00  
    mov al, 0x03        ; text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
    mov ah,09h
    int 21h
    jmp pedirDivisor   
    
    
    
continuar2:

    cmp tamanhoDivisor, 0     ;compara o tamanho do divisor com 0 (caso de divisor ser vazio)
    je erroDiv2                 ;se for igual a zero da erro    

    lea dx,enter      ;faz um enter    
    mov ah,09h
    int 21h                              
    lea dx,enter      ;faz outro enter    
    mov ah,09h
    int 21h
    
    jmp divisao

divisao:
    
    ;DEBUG
    
    ;xor bx,bx
    ;lea si,divisorarray
    ;lea di,dividendoarray
    ;call printDivs

    mov quociente , 0   ; Passa quociente para 0
    mov resto , 0       ; Passa resto para 0
    mov HO , 0          ; Passa HO para 0
    
    ;passar divisorarray para um numero so (divisor)
    xor bx,bx
    mov bl , 1
    mov ax , 1
    mul tamanhoDividendo 
    mov si, ax
    sub si,1      ;si comeca no lenght do dividendo - 1
    xor cx,cx
    xor ax,ax
    mov cx, 1
    jmp ConstrDiv ; Salta para o verificardivaux
    
ConstrDiv:             
         
    mov bl, [si]              ;Copia o elemento na posicao si do array para bx
    
    mov ax, cx                ;Multiplica o digito pela respetiva potencia de base 10
    mul bx                     
                               
    add divisor, ax            ;Adiciona ao divisor o resultado
                               
    mov bx, 10                 ;Multiplica a ultima potencia base 10 por 10
    mov ax, cx
    mul bx
    mov cx, ax
    
    cmp si,0            ;Verifica se ja precorreu todos os elementos do divisor
    je PreConstrAuxArr           ;Caso sim, constroi o array auxiliar
    
    dec si
                           
    jmp ConstrDiv
    
PreConstrAuxArr:        ;preparar registos para construir array auxiliar
    lea si, auxArr
    inc si
    mov bx, divisor
    mov [si] , bx
    inc si
    mov bx, divisor
    

    jmp ConstrAuxArr

ConstrAuxArr:

    add bx,bx           ;Multiplica o o valor do divisor
    mov [si] , bx       ;Copia o resultado da multiplicacao para o array
    
    cmp si, 10          ;Verifica se o contador chegou ao 10
    je iniciarDivisao   ;Caso tenha, salta para o iniciarDivisao
    
    inc si              ;Incrementa o contador 
     
    jmp ConstrAuxArr    ;Volta a correr o ConstrAuxArr
      

iniciarDivisao:
    lea si,[dividendoarray] ;inicializar si como o array do dividendo
    mov al, [si]            ;passar o primeiro digito do array para ax
              
              
    sub al, 48              ;passar al para decimal e armazenar em HO
    mov HO, al                         
    Call print_num_uns
    
    jmp verificardivaux ;Salta para o verificardivaux

verificardivaux:
    cmp tamanhoaux , 48 ; Verifica se o dividendoAux esta vazio compara com "0"
    je finalDiv         ; Caso esteja salta para o finalDiv

    jmp proximaIteracao

proximaIteracao:
    
    ;Verifical qual e o maior valor do array auxArr menor que HO

    jmp verificardivaux


finalDiv:
    mov ah, HO      ; Copia o valor do High Order para o resto
    mov resto, ah  

    xor cl, cl      ;Limpa o ecra

    mov si,0
    lea si,dividendoarray 

    mov AX, 03h
    int 10h 
    
    lea dx, msgQuociente     ; Imprime a string msgQuociente
    mov ah, 09h
    int 21h
    
    xor ah, ah     ; Imprime o valor do quociente
    mov al,quociente 
    Call print_num_uns

    lea dx,enter        ; Faz um enter
    mov ah,09h
    int 21h
    
    lea dx, msgResto     ; Imprime a string msgResto
    mov ah, 09h
    int 21h     
    
    xor ah,ah            ; Imprime o valor do resto
    mov al,resto 
    Call print_num_uns      
    
    mov ah, 00h      ; Servio para receber um caractere do teclado
    int 16h          ; Captura o caractere digitado
    
    
    int 20h

;-------------------------------------------------------------------------------------------------------------------


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
    
    mov dx, offset askRaiz
    mov ah, 9
    int 21h    
    
    validarRaiz:

    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,13            ;Se encontra enter
    je checkNumAlg         ;Da je para continuar
    cmp al,48            ;Se encontra 0
    je check0na1pos1Raiz     ;Da je para CHECK0na1pos1 
    cmp al,44            ;Se encontra 0
    je virgula           ;Da je para virgula
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroRaiz           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroRaiz           ;Da jump para erro se for maior que 57  
    cmp flagVirgula,1
    je  lerRaizReal
    jmp lerRaizInteiro    ;Da jump para funcao lerNumerador      
    
    
lerRaizInteiro:   
    sub al, 48
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    inc cl  ; incrementa o tamanho do numerador
    mov tamanhoRaizInteiro, cx   ;atualiza o tamanho do divisor
    inc si  ; incrementa o pointer do array para selecionar as posicoes
    jmp validarRaiz   
    
    
lerRaizReal:   
    sub al, 48
    mul bl
    xor ah,ah
    add raizReal,ax
    inc cl  ; incrementa o tamanho do numerador
    mov tamanhoRaizReal, cx   ;atualiza o tamanho do divisor
    inc di  ; incrementa o pointer do array para selecionar as posicoes
    sub bl, 9
    cmp tamanhoRaizReal,2
    je checkNumAlg
    jmp validarRaiz   
      
      

check0na1pos1Raiz:
    cmp tamanhoRaizInteiro, 0   ;compara o tamanho do dividendo com 0
    je erroRaiz                  ;se for igual a zero da erro
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
    mov al, 0x03        ;text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
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
    xor si,si 
    xor ax,ax
       

construirArrImpar:
    xor cx,cx
    mov cx,tamanhoRaizInteiro 
    xor bx,bx
    mov bl,[si]
    xor bh,bh
    mov [si],al 
    mov ax,bx   
    cmp si, cx
    je resets2  
    inc si
    jmp construirArrImpar
    
resets2:
    xor si,si
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
    mov si,ax
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
    xor si,si
    xor di,di
    
    
       
    
    mov dx, offset resultRaiz 
    mov ah, 9
    int 21h  
    
    sub tamanhoResultReal,1   
    mov cx, tamanhoResultReal
    mov ax,1
    call converte_e_mostra ; Chamar a função para converter e mostrar o número
    
    
    mov dx, offset msgVirgula
    mov ah, 9
    int 21h
    
    
    mov ax,resultReal
    xor ah,ah
    add al, '0'        ; Converter o resto para caractere ASCII
    mov ah, 14
    int 10h            ; Chamar interrupção do DOS
    
    
    
    
    
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h
    
    jmp start 
    
    
converte_e_mostra:
    mov dx,1
    cmp tamanhoResultReal,0
    je converte_loop
    ; Converte o valor em AX para uma string e a mostra diretamente
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
    add al, '0'        ; Converter o resto para caractere ASCII
    ; Mostrar o caractere diretamente
    mov ah, 14
    int 10h            ; Chamar interrupção do DOS
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

;-------------------------------------------------------------------------------------------------------------------

cc:
    call clearScreen     
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di
    
    mov tamanhoCC, 0

    mov dx, offset askCC
    mov ah, 9
    int 21h   
    

 

validarCC1Parte:
    mov cl, tamanhoCC
    cmp cl, 8
    je teste
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,48            ;Se encontra 0
    je check0na1pos1CC     ;Da je para CHECK0na1pos1
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroCC           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroCC         ;Da jump para erro se for maior que 57
    xor bl, bl
    xor ch, ch
    mov bl, 10

    call lerCC
    jmp validarCC1Parte

erroCC:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        ;text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
    mov ah,09h
    int 21h
    sub cl,1
    jmp cc

check0na1pos1CC:
    cmp tamanhoCC, 0   ;compara o tamanho do dividendo com 0
    je erroCC                 ;se for igual a zero da erro
    call lerCC  
    jmp validarCC1Parte

lerCC: 
    xor dx,dx
    xor cx,cx
    xor ah,ah 
    sub al,48
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    add tamanhoCC, 1  ;atualiza o tamanho do dividendo
    inc si  ; incrementa o pointer do array para selecionar as posicoes
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
    xor si, si
    lea si, CCArr ;carrega o array
    mov soma, 0
    xor cx,cx 
    xor dx,dx 
    xor ax,ax 

checkDigit1: 
    xor ax,ax 
    dec bl                 ;bl começa a 10 e e decrementado ate 2
    mov si, cx             ;posiçao do array igual a do ch
    mov al, bl              ;move o bl para o ax para multiplicar
    mov dl, [si]            ;move o algarismo na posiçao do si para o dl
    mul dl                  ;multiplica ax por dl
    add soma, ax                    ;adiciona o resultado da mul com a soma
    inc cx                  ;ch começa a 0 ate 8
    cmp bl, 2               ;compara bl com 2
    je checkDigit1div  
    jmp checkDigit1
    

checkDigit1div:
    xor ax,ax
    xor bx,bx
    xor cx,cx
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado 
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

    ;DIGITO IGUAL A 0
    cmp cl,0
    je versao
    jmp errado

checkDigit1dif0:

    cmp cl,bl
    je versao
    jmp errado


errado:   
    call clearScreen
    lea dx, msgInvalido     ;imprime a string msgErro
    mov ah, 09h
    int 21h
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado 
    jmp cc

versao: 
    mov cl, tamanhoCC     
    mov si, cx  
    cmp cx, 11
    je checkDigit2
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado
            
    cmp al, 48
    jb errover 
    cmp al,90           
    jg errover         ;Da jump para erro se for maior que 57       
    cmp al,57            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jbe versaoNumeros           ;da jump para erro se for menor que 49
    cmp al,65
    jae versaoLetras
    jmp errover

errover:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        ;text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
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
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroCD2           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroCD2         ;Da jump para erro se for maior que 57
    call lerCC  
    
    ;jmp checkDigit2calc  
    jmp checkDigit2div

erroCD2:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        ;text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
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
    lea dx, msgInvalido     ;imprime a string msgInvalido
    mov ah, 09h
    int 21h 
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado 
    jmp cc


CCFim:          
    xor dx,dx
    lea dx, msgValido     ;imprime a string msgValido   
    mov ah, 09h
    int 21h    
    xor ax,ax
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado 
    jmp start
    
    

;-------------------------------------------------------------------------------------------------------------------

nif:       
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di
    call clearScreen
    mov dx, offset askNIF
    mov ah, 9
    int 21h


validarInput:  
    mov cl, tamanhoNIF 
    cmp cl,9
    je validarNIF
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,48            ;Se encontra 0
    je check0na1posNIF     ;Da je para CHECK0na1pos1
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroNIF           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroNIF           ;Da jump para erro se for maior que 57
    call lerNIF     ;Da jump para funcao lerNumerador 
    jmp validarInput
    
    
lerNIF: 
    sub al,48
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    inc cl  ; incrementa o tamanho do Dividendo
    mov tamanhoNIF, cl  ;atualiza o tamanho do dividendo
    inc si  ; incrementa o pointer do array para selecionar as posicoes
    cmp cl,9 ; compara se o valor do Dividendo tem 5 algorismos, conta 0,1,2,3,4 
    ret


check0na1posNIF:
    cmp tamanhoNIF, 0   ;compara o tamanho do dividendo com 0
    je erroNIF                  ;se for igual a zero da erro
    call lerNIF
    jmp validarInput


erroNIF:
    pusha          
    mov ah, 0x00  
    mov al, 0x03        ;text mode 80x25 16 colours
    int 0x10
    popa
    
    lea dx, msgErro     ;imprime a string msgErro
    mov ah, 09h
    int 21h 
      
    lea dx,enter        ;Faz um enter
    mov ah,09h
    int 21h
    sub cl,1
    jmp validarInput
          
          
          
validarNIF:

    mov dx,ax
    mov ah,00h
    int 16h
    mov ax,dx 
    xor cx,cx 
    xor ax,ax

    mov bx,9
validarNIF_new: 
    mov si, cx
    mov ax, [si]
    xor ah,ah
    mul bx
    inc cx
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
    mov si, 8 
    cmp [si], 0
    je NIFValido
    jmp NIFInvalido

NIFdif0:   
    xor ax,ax
    mov ax,11
    mov si,8
    sub ax, dx
    mov dx, [si]   
    xor dh, dh
    cmp ax, dx
    je NIFValido
    jmp NIFInvalido

NIFInvalido:
    xor ax,ax
    xor dx,dx
    lea dx, msgInvalido     ;imprime a string msgInvalido
    mov ah, 09h
    int 21h
    mov ah,00h
    int 16h
    jmp NIF

NIFValido:
    xor ax,ax
    xor dx,dx
    lea dx, msgValido     ;imprime a string msgInvalido
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


;Funcs gerais
clearScreen:
    mov AX, 03h
    int 10h 
    ret

int 20h ; Terminar o programa
       
end start 