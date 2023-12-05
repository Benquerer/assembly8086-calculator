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
msgAsk1Parcela db "Digite a primeira parcela: $"
msgAsk2Parcela db "Digite a segunda parcela: $" 
parc1Array db 5 dup(0) 
parc2Array db 5 dup(0)
tamanhoParc1 db ?
result db 0 




; Divisao:
msgtest db "TESTE: $"
askDividendo db "Escolha o dividendo: $"
askDivisor db "Escolha o divisor: $"
msgQuociente db "Quociente: $"
msgResto db "Resto: $"
divisor db 0
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
auxArr db 10 dup (0)
dividendoAux db 5 dup (0)
tamanhoaux db 0

;CC  
askCC db "Introduza o CC : $" 
msgInvalido db "O numero que introduziu nao e valido"
msgValido db "O numero que introduziu e valido"
CCArr db 12 dup (0)
CCArrNovo db 12 dup (0)
soma dw 0
onze db 0  
dez dw 0
tamanhoCC dw 0

; NIF
askNIF db "Insira o NIF : $"
NIFArr db 9 dup (0)
tamanhoNIF db 0
somaNIF dw 0




start:
    mov dx, offset op1
    mov ah, 9
    int 21h

    mov dx, offset op2
    int 21h

    mov dx, offset op3
    int 21h

    mov dx, offset op4
    int 21h
    
    ;mov cx,ax
    mov ah,00
    int 16h
    mov ah, 09h           
    
    
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
    call clearScreen
    xor cl,cl 
    call clearScreen
    mov dx, offset msgAsk1Parcela   
    mov ah, 09h     
    int 21h         
    xor si, si
    lea si,parc1Array ;carrega o array 
    

validAlgParc1:
    mov ah,01h
    int 21h    
    
    cmp al,13            ;Se encontra enter
    je continuarAdd         ;Da je para continuarAdd
    cmp al,45            ;Se encontra -
    je checkMinus     ;Da je para checkMinus 
    cmp al,47            ;Se encontra 0
    je check0add     ;Da je para check0add
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroAdd           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroAdd           ;Da jump para erro se for maior que 57
    jmp lerParc1     ;Da jump para funcao lerParc
    
validAlgParc2:
    mov ah,01h
    int 21h    
    
    cmp al,13            ;Se encontra enter
    je inicSoma         ;Da je para continuarAdd
    cmp al,45            ;Se encontra -
    je checkMinus     ;Da je para checkMinus 
    cmp al,47            ;Se encontra 0
    je check0add     ;Da je para check0add
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroAdd           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroAdd           ;Da jump para erro se for maior que 57
    jmp lerParc2     ;Da jump para funcao lerParc  
    
lerParc1:
    sub al,48
    mov [si],al
    inc si
    inc cl
    mov tamanhoParc1, cl
    cmp cl,4
    ja continuarAdd
    jmp validAlgParc1 

lerParc2:
    sub al,48
    mov [di],al  
    inc di
    inc cl
    mov tamanhoParc1, cl
    cmp cl,4
    ja inicSoma
    jmp validAlgParc2
    
continuarAdd: 
    xor cl,cl
    lea dx,enter      ;faz um enter    
    mov ah,09h
    int 21h                              
    lea dx,enter      ;faz outro enter    
    mov ah,09h
    int 21h
    xor ax,ax           
    mov dx, offset msgAsk2Parcela   
    mov ah, 09h     
    int 21h         
    xor di, di
    lea di,parc2Array ;carrega o array
    jmp validAlgParc2
    
checkMinus:
check0add:
erroAdd:
inicSoma:  
somaLoop:


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
    lea si,dividendoarray ;carrega o array
   
             

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
    jmp ConstrAuxArr ; Salta para o verificardivaux
    

;-------------------DEBUG DIVISAO--------------------

printDivs:
   xor ax,ax
   mov al,[si]
   
   Call print_num_uns
     
   inc si
   inc bl
   
   cmp bl, tamanhoDivisor
   je pre
   
   jmp printDivs
    
pre:
    xor bx,bx 
    
printDivd:
   xor ax,ax
   mov al,[di]
   
   Call print_num_uns
   
   inc di
   inc bl
   
   cmp bl, tamanhoDividendo
   je finalDiv
   
   jmp printDivd 

pre2:
    xor bx,bx
    
    jmp PrintAuxArr

PrintAuxArr:
   xor ax,ax
   mov al,[di]
   
   Call print_num_uns
   
   lea dx,enter        ;Faz um enter
   mov ah,09h
   int 21h
   
   inc di
   inc bl
   
   cmp bl, countDiv
   je finalDiv
   
   jmp PrintAuxArr

;----------------------------------------------------

ConstrAuxArr:
    xor ah,ah
    mov al, countDiv ;Copia o valor do contador para o al
            
    lea si, auxArr   ;Copia o auxArr para o array
    mov [si] , bx    ;Copia o resultado da multiplicacao para o array

    mov al, 10       ;Copia 10 para o al
    
    ;NESTE MOMENTO PARA DEBUG ESTA A SIMULAR DIVISOR = 1
    add bl,bl      ;Multiplica o o valor do divisor | suposto usar algoritmo soma andre

    cmp countDiv, al    ;Verifica se o contador chegou ao 10
    je PrintAuxArr      ;DEBUG
    
    ;je iniciarDivisao   ;Caso tenha, salta para o iniciarDivisao
    
    inc countDiv     ;Incrementa o contador 
     
    jmp ConstrAuxArr ;Volta a correr o ConstrAuxArr
      

iniciarDivisao:
    lea si,[dividendoarray] ;inicializar si como o array do dividendo
    mov al, [si]            ;passar o primeiro digito do array para ax
              
              
    sub al, 48              ;passar al para decimal e armazenar em HO
    mov HO, al                         
    Call print_num_uns
    
    jmp verificardivaux ;Salta para o verificardivaux

verificardivaux:
    cmp tamanhoaux , 48 ; Verifica se o dividendoAux esta vazio
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

    ;mov dx, offset 
    ;mov ah, 9
    ;int 21h

;-------------------------------------------------------------------------------------------------------------------

cc:
    call clearScreen     
    xor cl,cl
    xor di,di  
    
    mov CCArr, 0    
    mov tamanhoCC, 0

    mov dx, offset askCC
    mov ah, 9
    int 21h 
    

 

validarCC1Parte:
    CMP cl, 8
    je teste
    INC cl          ;Incrementar cl até chegar a 8
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
    jmp validarCC1Parte

check0na1pos1CC:
    cmp tamanhoCC, 0   ;compara o tamanho do dividendo com 0
    je erroCC                 ;se for igual a zero da erro
    call lerCC  
    jmp validarCC1Parte

lerCC:  
    sub al,48
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    add tamanhoCC, 1  ;atualiza o tamanho do dividendo
    inc si  ; incrementa o pointer do array para selecionar as posicoes
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
    call lerCC
    mov cl,al
    mov ax, soma 
    mov bl, 11
    div bl
    cmp ah,0
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
    jmp cc

versao:
    mov si, tamanhoCC  
    mov cx, tamanhoCC
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado
    cmp cx, 10
    je checkDigit2
            
    cmp al, 48
    jb errover 
    cmp al,90           
    jg errover         ;Da jump para erro se for maior que 57       
    cmp al,57            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jl versaoNumeros           ;da jump para erro se for menor que 49
    cmp al,65
    ja versaoLetras
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
    jmp versao  
    
 
versaoNumeros:
    mov si, tamanhoCC
    call lerCC
    jmp versao 
    
versaoLetras:
    sub al, 7
    mov si, tamanhoCC
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
    xor cx,cx
    xor ax,ax
    xor bx,bx
    xor dx,dx 
    mov soma,0
    
    jmp checkDigit2calc

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
    jmp checkDigit2:


checkDigit2calc:
    inc cx 
    mov bx, 2
    mov si, cx
    mov ax, [si]
    mul bx      
    mov [di], ax
    cmp cx, 12
    je resetValores
    jmp checkDigit2calc



resetValores:
    xor cx,cx
    xor ax,ax
    mov cx, 1


reconstruirArr:             ;Reconstroi o array para os numeros impares
    mov ax, ax
    mov di, cx
    mov ax, [di]
    cmp ax, 10
    jge maiorque10
    add soma, ax
    mov [si], ax
    inc cx
    inc cx
    cmp cx, 13
    je checkDigit2div
    jmp reconstruirArr


maiorque10:
    sub ax, 9
    add soma, ax
    mov [si], ax
    inc cx
    inc cx
    cmp cx, 13
    je checkDigit2div
    jmp reconstruirArr


checkDigit2div: 
    mov ax, soma
    xor dx,dx
    xor bx,bx 
    mov bx, 10
    div bx
    cmp ah, 0 ;COMPARA COM O CD2
    je CCFim
    jmp invalido

invalido:
    call clearScreen
    lea dx, msgInvalido     ;imprime a string msgInvalido
    mov ah, 09h
    int 21h
    jmp cc


CCFim:
    lea dx, msgValido     ;imprime a string msgValido









;-------------------------------------------------------------------------------------------------------------------

nif:
    call clearScreen
    mov dx, offset askNIF
    mov ah, 9
    int 21h

    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di

    lea si, NIFArr

validarInput:
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,48            ;Se encontra 0
    je check0na1posNIF     ;Da je para CHECK0na1pos1
    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroNIF           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroNIF           ;Da jump para erro se for maior que 57
    jmp lerNIF     ;Da jump para funcao lerNumerador
    
    
lerNIF: 
    sub al,48
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    inc cl  ; incrementa o tamanho do Dividendo
    mov tamanhoNIF, cl  ;atualiza o tamanho do dividendo
    inc si  ; incrementa o pointer do array para selecionar as posicoes
    cmp cl,9 ; compara se o valor do Dividendo tem 5 algorismos, conta 0,1,2,3,4 
    jne validarInput
    xor cx,cx
    mov somaNIF, 0
    jmp validarNIF  


check0na1posNIF:
    cmp tamanhoNIF, 0   ;compara o tamanho do dividendo com 0
    je erroNIF                  ;se for igual a zero da erro
    jmp lerNIF


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

    mov bx,9
validarNIF_new: 
    mov si, cx
    mov ax, [si]
    mul bx
    inc cx
    dec bx
    add somaNIF, ax 
    
    mov dx,ax
    mov ah,00h
    int 16h
    mov ax,dx
    
    cmp cx, 9
    je validarNIF2
    jmp validarNIF_new

validarNIF2:
    xor dx,dx
    xor bx,bx
    mov onze, 11
    mov bx, 11
    mov ax, somaNIF
    div bx
    cmp dx, 0
    je NIF0
    jmp NIFdif0


NIF0:
    mov si, 9
    cmp [si], 0
    je NIFValido
    jmp NIFInvalido

NIFdif0:   
    xor ax,ax
    mov ax,11
    mov si,8
    sub ax, dx
    mov dx, ax
    mov ax, [si]
    cmp [si], dx
    je NIFValido
    jmp NIFInvalido

NIFInvalido:
    xor ax,ax
    xor dx,dx
    call clearScreen
    lea dx, msgInvalido     ;imprime a string msgInvalido
    mov ah, 09h
    int 21h
    ;call clearScreen
    jmp NIF

NIFValido:
    xor ax,ax
    xor dx,dx
    lea dx, msgValido     ;imprime a string msgInvalido
    mov ah, 09h
    int 21h



DEFINE_PRINT_NUM_UNS

tabelaConversao:
    ; Converta o caractere para um valor numérico usando a tabela de conversão
    sub al, '0'   ; Subtrai o valor ASCII '0' para obter um número
    sub al, 'A'   ; Subtrai o valor ASCII 'A' para letras maiúsculas

    ; Agora AL contém o valor numérico correspondente ao caractere original
    ; Faça o que for necessário com o valor, por exemplo, armazene em uma variável
    ret  
    
;Funcs gerais
clearScreen:
    mov AX, 03h
    int 10h 
    ret

int 20h ; Terminar o programa
       
end start 