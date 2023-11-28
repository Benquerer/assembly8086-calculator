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
tamanhoParcela db 0 
erroInser db "Digito invalido!"


; Divisao:
msgtest db "TESTE: $"
askDividendo db "Escolha o dividendo: $"
askDivisor db "Escolha o divisor: $"
msgQuociente db "Quociente: $"
msgResto db "Resto: $"
divisor db 0
divisorarray db 5 dup 0
dividendoarray db 5 dup 0
arrAux db 5 dup 0
tamanhoDividendo db 0
tamanhoDivisor db 0
quociente db 0
resto db 0
HO db 0
countDiv db 0
aux1 db 0
auxArr db 0 dup 10
dividendoAux db 5 dup 0
tamanhoaux db 0

;CC  
askCC db "Introduza o CC : $" 
msgInvalido db "O numero que introduziu nao e valido"
msgValido db "O numero que introduziu e valido"
CCArr db 15 dup 0
CCArrNovo db 15 dup 0
soma dw 0
onze db 0  
dez dw 0
tamanhoCC db 0

; NIF
askNIF db "Insira o NIF : $"
NIFArr db 9 dup 0
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
    mov dx, offset msgAsk1Parcela
    mov ah, 09h
    int 21h
    jmp lerDigito
    
validarParcela:

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
    
    
lerDigito:

    ; Recebendo a entrada do usuario
    mov ah, 01h
    int 21h 
    cmp al, 45       ;verificar se houve o imput de um -
    je inseriuMenos
    ;verificar o usuario terminou o input da parcela (enter)
    cmp al, 13
    je lerDigito 
    ;verificar se o input esta entre 0 e 9 
    cmp al,48
    jb erroInsercao
    cmp al,57
    ja erroInsercao
    jmp lerDigito
 
    

inseriuMenos: 
    cmp tamanhoParcela, 0
    jne erroInsercao
    mov tamanhoParcela, 1
    jmp lerDigito

erroInsercao:
    mov dx, offset erroInser
    mov ah,09h
    int 21h


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
    mov al, countDiv ;Copia o valor do contador para o al
    mul divisor      ;Multiplica o divisor pelo al(contador) e armazena o valor em ax

    lea si, auxArr   ;Copia o auxArr para o array
    mov [si] , ax    ;Copia o resultado da multiplicacao para o array

    mov al, 10       ;Copia 10 para o al

    cmp countDiv, al    ;Verifica se o contador chegou ao 10
    je PrintAuxArr      ;DEBUG
    ;je iniciarDivisao   ;Caso tenha, salta para o iniciarDivisao
    
    inc countDiv     ;Incrementa o contador
    
    xor bx,bx
    lea di,auxArr 
    jmp ConstrAuxArr 
     
    ;jmp ConstrAuxArr ;Volta a correr o ConstrAuxArr
      

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

    mov dx, offset askCC
    mov ah, 9
    int 21h
    xor si, si
    lea si, CCArr ;carrega o array
 

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
    cmp CCArr, 0   ;compara o tamanho do dividendo com 0
    je erroCC                 ;se for igual a zero da erro
    jmp validarCC1Parte

lerCC:
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    add tamanhoCC, 1  ;atualiza o tamanho do dividendo
    inc si  ; incrementa o pointer do array para selecionar as posicoes
    ret
      
teste:    
    mov soma, 0   
    mov cx, soma
    xor cx,cx 
    xor dx,dx 
    xor ah,ah 

checkDigit1:  
    dec bx                  ;bl começa a 10 e e decrementado ate 2
    mov si, cx              ;posiçao do array igual a do ch
    mov ax, bx              ;move o bl para o ax para multiplicar
    mov dx, [si]            ;move o algarismo na posiçao do si para o dl
    mul dx                  ;multiplica ax por dl
    add soma, ax                    ;adiciona o resultado da mul com a soma
    inc cx                  ;ch começa a 0 ate 8
    cmp bx, 2               ;compara bl com 2
    je checkDigit1div:  
    jmp checkDigit1

checkDigit1div:
    xor ah,ah
    xor al,al
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado
    xor ah,ah
    mov onze, 11
    mov ax, soma
    div onze
    cmp dx,0
    je checkDigit1igual0
    sub dx,11
    jmp checkDigit1dif0

checkDigit1igual0:

    ;DIGITO IGUAL A 0
    cmp al,0
    je versao
    jmp errado

checkDigit1dif0:

    cmp ax,dx
    je versao
    jmp errado


errado:   
    call clearScreen
    lea dx, msgInvalido     ;imprime a string msgErro
    mov ah, 09h
    int 21h
    jmp cc

versao:
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,'A'            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jl errover           ;da jump para erro se for menor que 49
    cmp al,'z'           
    jg errover         ;Da jump para erro se for maior que 57
    cmp al, 49
    jb errover
    cmp al,57
    ja errover
    call tabelaConversao
    call lerCC
    xor cl,cl
    xor ax,ax
    xor bx,bx
    xor di, di
    lea di, CCArrNovo  ;carrega o array
    jmp checkDigit2

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


checkDigit2:
    ; Recebendo a entrada do usuario
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado

    cmp al,49            ;VERIFICA SE O VALOR INTRODUZIDO ESTA ENTRE 1 E 9 (49,57 em ASCII)
    jb erroCD2           ;da jump para erro se for menor que 49
    cmp al,57            
    ja erroCD2         ;Da jump para erro se for maior que 57
    call lerCC
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
    mov si, cx
    mov ax, [si]
    mov bx, 2
    mul bx    
    mov Dez,10
    cmp ax,Dez
    mov [di], ax
    cmp cx, 12
    je resetValores
    jmp checkDigit2calc



resetValores:
    xor cx,cx
    xor ax,ax
    mov cx, 1


reconstruirArr:             ;Reconstroi o array para os numeros impares
    mov di, cx
    mov ax, [di]
    cmp ax, 10
    jg maiorque10
    mov [si], ax
    inc cx
    inc cx
    cmp cx, 12
    je checkDigit2div
    jmp reconstruirArr


maiorque10:
    sub ax, 9
    add soma, ax
    mov [si], ax
    inc cx
    inc cx
    cmp cx, 12
    je checkDigit2calc
    jmp reconstruirArr


checkDigit2div:
    xor dx,dx
    xor bx,bx 
    mov bx,Dez
    div soma, bx
    cmp dx, 0
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
    mov bx,9
    mov si, cx
    mov ax, [si]
    mul bx
    inc cx
    dec bx
    add somaNIF, ax
    cmp cx, 9
    je validarNIF2
    jmp validarNIF

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