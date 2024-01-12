                                                                                            
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

;Subtracao
tamanhoMinuendo db 0
subtraMaiorMinu db 0
limitadorSubtracao db 10 
;arrays 
minuendo db 10 dup(0)
subtraendo db 10 dup(0)
resSubtracao db 10 dup(0) 
;mensagens
msgMinuendo db "Digite o minuendo: $"
msgSubtraendo db "Digite o subtraendo: $"
msgResSub db "Resuldado subtracao: $"
msgResSubInv db "Resuldado subtracao: -$" 
msgErroSub db "Digito invalido! pressione qualquer tecla para sair... $"


;Multiplicacao
askFator1 db "Escolha o primeiro Fator: $"
askFator2 db "Escolha o segundo Fator: $"
fatorArr1 db 10 dup (0)   
fatorArr2 db 10 dup (0)
tamanhoFator1 db 0  
tamanhoFator2 db 0



; Divisao:
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
quociente db 0
countConstrDiv db 0
counterAuxArr db 2
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

    
    call clearScreen    ;chama a rotina para limpar a tela
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di 

    
    mov si, offset parc1    ;carrega o endereco do primeiro array no si
    
    ;primeiro array
    lea dx, msgParc1    ;carrega o endereco da msgParc1 e coloca na tela
    mov ah , 09h
    int 21h
    call lerParc1   ;iniciar rotina para ler a primeira parcela
    call clearScreen    ; rotina para limpar a tela
    mov tamanhoParc1,cl     ;guarda o tamanho da parcela introduzida 
    
    ; segundo array
    xor cl,cl       ;limpa cl para contar o tamanho da proxima parcela
    mov di, offset parc2    ;carrega o endereco do segundo array em di
    lea dx, msgParc2    ;carrega o endereco da msgParc2 e coloca na tela
    mov ah , 09h
    int 21h
    call lerParc2   ;iniciar rotina para ler a segunda parcela
    call clearScreen    ;rotina para limpar a tela 
    
    ;preparar resultado (definir tamanho da soma baseado na quantidade de digitos de cada parcela)
    cmp cl, tamanhoParc1    ;cl esta com o tanho da segunda parcela
    jae maior   ;pular para a etiqueta maior, se forem iguais, ou a segunda tiver mais digitos
    jb menor    ;pular para a etiqueta maior, se a primeira parcela tiver mais digitos
    

maior:
    mov tamanhoSoma, cl     ;guarda o numero de digitos da maior parcela (a segunda, que esta em cl)
    jmp prepRes     ;jump para preparacao do resultado
    
menor: 
     xor cl,cl  ;limpar cl
     mov cl, tamanhoParc1   ;passa para o cl a quantidade de digitos da maior parcela
     mov tamanhoSoma, cl    ;guarda o numero de digitos.
  

prepRes:  
    xor cl,cl   ;limpa o cl
    lea dx,msgResSoma   ;carrega o endereco da mensagem de resultado no dx e a coloca na tela
    mov ah,09h
    int 21h
    
    dec si  ;retorna o si para a ultima posicao do array (sai da leitura de parcela com 1 a mais)
    dec di  ;retorna o di para a ultima posicao do array (sai da leitura de parcela com 1 a mais)
    mov bx, offset resultadoSoma    ;carrega para o bx o endereco do array de resultado
    
    mov ch,primeiraNegSoma  ;coloca no ch a "flag" de negativo da primeira parcela
    cmp ch,segundaNegSoma   ;compara com a "flag" de negativo da segunda parcela
    je somar    ;se as duas tiverem o mesmo sinal, pula para a soma normal
    
    ;codigo para sinais diferentes
    
    
lerParc1:   
    
    cmp cl, limitadorSoma  ;compara o cl (contador) com o limitador da soma 
    je backSoma     ;retorna se chegou ao limite
    mov ah, 01h     ;pedir input 
    int 21h 
    cmp al,13   ;checkar enter
    je backSoma     ;retornar se o input for a tecla enter 
    cmp al,45   ;checkar negativo
    je parc1neg     ; verificar se negativo esta na posicao correta
    cmp al,48   ;checkar menor que 0
    jb erroSoma     ; jump para tratar erro de numeros
    cmp al,57   ;checkar maior que 9
    ja erroSoma     ; jump para tratar erro de numeros
    ;se passou por todas as checkagens, adiciona ao array
    sub al,48   ;converte o numero 
    mov [si],al ;coloca na posicao atual do array
    inc si      ;incrementa o pointer do array
    inc cl      ;incrementa o contador
    jmp lerParc1    ;loop
    
lerParc2:   
    
    cmp cl, limitadorSoma ;compara o cl (contador) com o limitador da soma 
    je backSoma     ;retorna se chegou ao limite
    mov ah, 01h     ;pedir input
    int 21h
    cmp al,13   ;checkar enter
    je backSoma     ;retornar se o input for a tecla enter 
    cmp al,45   ;checkar negativo
    je parc2neg    ; verificar se negativo esta na posicao correta 
    cmp al,48   ;checkar menor que 0
    jb erroSoma     ; jump para tratar erro de numeros
    cmp al,57   ;checkar maior que 9
    ja erroSoma     ; jump para tratar erro de numeros
    ;se passou por todas as checkagens, adiciona ao array
    sub al,48   ;converte o numero 
    mov [di],al     ;coloca na posicao atual do array
    inc di      ;incrementa o pointer do array
    inc cl      ;incrementa o contador
    jmp lerParc2   ;loop


backSoma:
    ret     ;retorna para o "atual "call 
    
parc1neg:
    cmp cl,0    ;verifica se o contador ainda esta a 0
    jne erroNegativo    ;caso nao esteja, trata o erro de negativo fora de posicao
    inc primeiraNegSoma     ;se a posicao for valida, atualiza a flag referente a respectiva parcela 
    jmp lerParc1 ;retorna a leitura
    
parc2neg:
    cmp cl,0    ;verifica se o contador ainda esta a 0
    jne erroNegativo    ;caso nao esteja, trata o erro de negativo fora de posicao
    inc segundaNegSoma  ;se a posicao for valida, atualiza a flag referente a respectiva parcela 
    jmp lerParc2    ;retorna a leitura
    

erroNegativo:
    call clearScreen    ;rotina para limpar a tela
    xor ax,ax  
    lea dx,msgErroNegSoma  ;carrega a msg de erro na posicao do '-' e coloca na tela
    mov ah,09h
    int 21h
    mov ah,01h  ;espera qualquer tecla do usuario para terminar o programa
    int 21h
    int 20h     ;termina o programa
    
erroSoma:
    call clearScreen    ;rotina para limpar a tela
    xor ax,ax
    lea dx,msgErroSoma  ;carrega a msg de erro nos digitos da soma e coloca na tela
    mov ah,09h
    int 21h
    mov ah,01h  ;espera qualquer tecla do usuario para terminar o programa
    int 21h
    int 20h  ;termina o programa

    
somar:    
    cmp cl,tamanhoSoma      ;verifica se o contador chegou no limitador da soma
    je finalizar    ;se sim, pula para a finalizacao
    xor ax,ax  
    mov al,[si]     ;coloca em al o atual valor do indice do primeiro array
    add al,[di]     ;adiciona o valor que esta em di
    cmp al,10       ;verifica se existe necessidade de carry (si + di >=10)
    jae carry       ;rotina para carry
    add al,[bx]     ;adiciona o valor que ja estava na posicao
    mov [bx],al     ;coloca o resultado no array
    dec si          ;regride o pointer da primeira parcela
    dec di          ;regride o pointer da segunda parcela
    inc bx          ;incrementa o pointer do array resultado
    inc cl          ;incrementa o contador
    jmp somar       ; loop

carry:
    sub al, 0Ah     ;em caso de carry, retira 10 do resultado da soma (sobrando o que ficaria na posicao em al)
    add [bx],al     ;coloca a sonbra na posicao 
    dec si          ;regride o pointer da primeira parcela
    dec di          ;regride o pointer da segunda parcela
    inc bx          ;incrementa o pointer do array resultado
    inc cl          ;incrementa o contador
    add [bx],1      ;coloca o carry na posicao atual do array (foi incrementado, entao esta no index seguinte ao inicio da etiqueta)
    jmp somar       ;volta para a soma
    

dispRes:
    cmp cl,tamanhoSoma  ;compara o contador com o limitador da soma (tamanho do resultado)
    ja backSoma     ;se passou, retorna o call (usa o ja para tratar overflows)
    mov al,[bx]    ;coloca no al o atual digito para ser mostrado na tela
    add al,48       ;converte o valor para ascii
    mov ah, 0Eh 
    int 10h     ;coloca o valor em al na tela
    dec bx      ;regride o pointer do resultado
    inc cl      ;incrementa o contador
    jmp dispRes     ;loop
    
finalizar:
    xor cl,cl
    xor ax,ax
    mov cl,primeiraNegSoma      ;coloca em cl a "flag" de sinal utuilizada na soma
    cmp cl,1    ;verifica se a flag da soma foi 1
    je finalizarNeg     ;se sim, a soma foi entre dois numeros negativos, entao faz a finalizacao adequada
    xor cl,cl   ;limpa o cl para servir de contador
    call dispRes    ;rotina para display do resultado
    jmp fimSoma     ;finalizar o programa

finalizarNeg:
    xor cl,cl
    mov al,45   ;carrega em al o valor ascii de '-' e coloca na tela
    mov ah,0Eh 
    int 10h
    xor ax,ax
    call dispRes ;rotina para display do resultado    

    
    
fimSoma:
    int 20h     ;finaliza o programa
    
;-------------------------------------------------------------------------------------------------------------------
Subt:
    call clearScreen    ;chama a rotina para limpar a tela
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di
    
    mov si, offset minuendo  ;carrega o endereco do primeiro array em si
    lea dx, msgMinuendo     ;carrega a mensagem do minuendo em dx e coloca na tela
    mov ah,09h
    int 21h
    
    call lerMinuendo        ; rotina para ler o minuendo
    mov tamanhoMinuendo,cl  ; guarda o tamanho do minuendo (contador cl apos a rotina de leitura)  
    call clearScreen        ;limpar tela
    
    
    xor cl,cl
    mov di, offset subtraendo    ;carrega o endereco do primeiro array em di
    lea dx, msgSubtraendo        ;carrega a mensagem do subtraendo em dx e coloca na tela
    mov ah,09h
    int 21h
    call lerSubtraendo  ;rotina para ler o subtraendo
    call clearScreen    ;limpar tela
    
    dec si  ;retorna o pointer do array para o ultimo numero
    dec di  ;retorna o pointer do array para o ultimo numero
    
    cmp cl, tamanhoMinuendo     ;compara o cl (contador do subtraendo) com o tamanho do minuendo
    ja prepSubInv               ; garante a subtracao com o numero de mais digitos em cima 

    mov bx, offset subtraendo  ;coloca em bx o endereco do array subtraendo
    mov dl,[bx]                ;coloca em dl o valor do primeiro digito
    xor bx,bx
    mov bx, offset minuendo     ;coloca em bx o endereco do array minuendo
    cmp dl,[bx]                 ;compara o primeiro digito do array minuendo com o primeiro do array subtraendo
    ja  prepSubInv              ;se o primeiro digito do subtraendo for maior que o do minuendo, vai para a sub invertida
    jmp prepSub                 ;caso contrario, subtracao normal
    
    ;falta adicionar lohica acima para multiplas casasas
        
    

lerMinuendo:
    cmp cl, limitadorSubtracao  ;compara o cl (contador) com o limitador da subtracao 
    je backSubtracao     ;retorna se chegou ao limite
    mov ah, 01h     ;pedir input 
    int 21h 
    cmp al,13   ;checkar enter
    je backSubtracao     ;retornar se o input for a tecla enter
    cmp al,48   ;checkar menor que 0
    jb erroSubtracao     ; jump para tratar erro de numeros
    cmp al,57   ;checkar maior que 9
    ja erroSubtracao     ; jump para tratar erro de numeros
    ;se passou por todas as checkagens, adiciona ao array
    sub al,48   ;converte o numero 
    mov [si],al ;coloca na posicao atual do array
    inc si      ;incrementa o pointer do array
    inc cl      ;incrementa o contador
    jmp lerMinuendo    ;loop
    
 
lerSubtraendo:
    cmp cl, limitadorSubtracao  ;compara o cl (contador) com o limitador da subtracao 
    je backSubtracao     ;retorna se chegou ao limite
    mov ah, 01h     ;pedir input 
    int 21h 
    cmp al,13   ;checkar enter
    je backSubtracao     ;retornar se o input for a tecla enter
    cmp al,48   ;checkar menor que 0
    jb erroSubtracao     ; jump para tratar erro de numeros
    cmp al,57   ;checkar maior que 9
    ja erroSubtracao     ; jump para tratar erro de numeros
    ;se passou por todas as checkagens, adiciona ao array
    sub al,48   ;converte o numero 
    mov [di],al ;coloca na posicao atual do array
    inc di      ;incrementa o pointer do array
    inc cl      ;incrementa o contador
    jmp lerSubtraendo    ;loop  

erroSubtracao:
    call clearScreen    ;rotina para limpar a tela
    xor ax,ax
    lea dx,msgErroSub  ;carrega a msg de erro nos digitos subtracao e coloca na tela
    mov ah,09h
    int 21h
    mov ah,01h  ;espera qualquer tecla do usuario para terminar o programa
    int 21h
    int 20h  ;termina o programa  

backSubtracao:
    ret      ;retorna para o call "mais recente"

prepSub:
    xor cl,cl
    mov bx, offset resSubtracao   ;colocar o endereco do array de resultado em bx 

subtrair:  
    ;aqui, o primeiro array representa o minuendo, o segundo o subtraendo
    cmp cl,tamanhoMinuendo ;verifica se o contador chegou no limitador da subt
    je prepResSubt  ;caso o limitador tenha sido igualado, preparar para fazer o display do resultado
    mov al,[si]     ;coloca em al o valor do indice do primeiro array
    cmp [di],al     ;compara o valor do indice do segundo array com o primeiro
    ja emprest      ;caso o segundo seja maior, jump para a logica de "emprestar 1"
    sub al,[di]     ;caso contrario, subtrai o segundo valor do primeiro
    mov [bx],al     ;guardar digito no array de resultados
    dec si          ;regredir o pointer do primeiro array
    dec di          ;regredir o pointer do segundo array
    inc bx          ;incrementar o pointer do resultado
    inc cl          ;incrementar o contador
    jmp subtrair    ;loop
    
    
emprest:
    ;aqui, o primeiro array representa o minuendo, o segundo o subtraendo
    dec si          ;decrementa o pointer do primeiro array (avancar uma casa a esquerda)
    sub [si],1      ;subtrair 1 
    inc si          ;retornar a posicao original
    add al,10       ;adicionar ao al o valor retirado do primeiro array
    sub al,[di]     ;subtrair o valor do segundo array, agora menor que o al
    mov [bx],al     ;guardar digito no array de resultados
    ;mesma manipulacao de ponteiros e contador de uma sub normal     
    dec si          
    dec di
    inc bx
    inc cl
    jmp subtrair    ;loop de volta para a subtracao

prepSubInv:
    mov bx, offset resSubtracao ;colocar o endereco do array de resultado em bx 
    mov tamanhoMinuendo,cl      ;definir como limite da soma o valor em cl (tamanho subtraendo)
    xor cl,cl    
        
SubInv:
    ;aqui, o primeiro array representa o subtraendo, o segundo o minuendo
    cmp cl,tamanhoMinuendo  ;verifica se o contador chegou no limitador da subt
    je prepResSubtInv   ;caso o limitador tenha sido igualado, preparar para fazer o display do resultado
    mov al,[di]         ;coloca em al o valor do indice do primeiro array
    cmp [si],al     ;compara o valor do indice do segundo array com o primeiro
    ja emprestInv   ;caso o segundo seja maior, jump para a logica de "emprestar 1"
    sub al,[si]     ;caso contrario, subtrai o segundo valor do primeiro
    mov [bx],al     ;guardar digito no array de resultados
    dec si          ;regredir o pointer do segundo array
    dec di          ;regredir o pointer do primeiro array
    inc bx          ;incrementar o pointer do resultado
    inc cl          ;incrementar o contador
    jmp SubInv      ;loop

emprestInv:
    ;aqui, o primeiro array representa o subtraendo, o segundo o minuendo
    dec di      ;decrementa o pointer do primeiro array (avancar uma casa a esquerda)
    sub [di],1  ;subtrair 1
    inc di      ;retornar a posicao original
    add al,10       ;adicionar ao al o valor retirado do primeiro array  
    sub al,[si]     ;subtrair o valor do segundo array, agora menor que o al
    mov [bx],al     ;guardar digito no array de resultados
    ;mesma manipulacao de ponteiros e contador de uma sub normal     
    dec si
    dec di
    inc bx
    inc cl
    jmp SubInv   ;loop de volta para a subtracao invertida
     
    
prepResSubt:
    xor cl,cl
    xor ax,ax
    lea dx,msgResSub    ;como um normal foi feita, carrega a mensagem de resultado
    mov ah,09h
    int 21h     ;coloca na tela a mensagem carregada
    call dipsResSub ;rotina de mostrar resultado
    jmp fimSubt     ; finalizar
    
prepResSubtInv:
    xor cl,cl
    xor ax,ax
    lea dx,msgResSubInv ;como um invertida foi feita, carrega a mensagem adequada de resultado
    mov ah,09h
    int 21h      ;coloca na tela a mensagem carregada
    call dipsResSub ;rotina de mostrar resultado
    jmp fimSubt   ; finalizar

 
dipsResSub:
    cmp cl,tamanhoMinuendo ;verificar se o contador esta no limitador da sub 
    ja backSubtracao    ;se sim, retorna ao call para finalizar o programa
    mov al,[bx]     ;colocar em al o valor atual de bx    
    add al,48       ;converter para ascii
    mov ah, 0Eh      
    int 10h         ;colocar na tela
    dec bx          ;regride o ponteiro
    inc cl          ;incrementar contador
    jmp dipsResSub  ;loop

    
fimSubt:
    int 20h
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
    mov quociente , 0   ; Passa quociente para 0
    mov resto , 0       ; Passa resto para 0
    mov HO , 0          ; Passa HO para 0
    
    ;passar divisorarray para um numero so (divisor)
    xor bx,bx
    mov si, OFFSET divisorarray
    mov bl , 1
    mov ax ,1
    mul tamanhoDivisor 
    dec ax
    mov countConstrDiv, al                    
    add si,ax                 ;si comeca no lenght do dividendo - 1
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
    
    cmp countConstrDiv ,0            ;Verifica se ja precorreu todos os elementos do divisor
    je PreConstrAuxArr           ;Caso sim, constroi o array auxiliar
    
    dec si
    dec countConstrDiv
                           
    jmp ConstrDiv
    
PreConstrAuxArr:        ;preparar registos para construir array auxiliar
    mov si, OFFSET auxArr
    inc si
    inc si
    mov ax, divisor
    mov [si] , ax
    mov ax, divisor
    inc si
    inc si
    

    jmp ConstrAuxArr

ConstrAuxArr:

    add ax,divisor      ;Multiplica o o valor do divisor
    mov [si] , ax       ;Copia o resultado da multiplicacao para o array
    
    inc counterAuxArr   ;Incrementa o contador
    
    mov bl,counterAuxArr 
    cmp bl, 10          ;Verifica se o contador chegou ao 10
    je iniciarDivisao   ;Caso tenha, salta para o iniciarDivisao
    
    inc si
    inc si 
     
    jmp ConstrAuxArr    ;Volta a correr o ConstrAuxArr
      

iniciarDivisao:
    xor ax,ax
    xor cx,cx
    
    mov si, OFFSET dividendoarray       ;inicializar si como o array do dividendo
    mov al, [si]                        ;passar o primeiro digito do array para ax
    mov bl , tamanhoDividendo
    mov tamanhoaux, bl    ;passar o tamanho do dividendo para o tamanho do array auxiliar         
    xor bx,bx
              
    mov HO, al                         

    
    jmp verificardivaux           ;Salta para o verificardivaux

verificardivaux:
    cmp tamanhoaux , 0  ;Verifica se o dividendoAux esta vazio compara com "0"
    je finalDiv         ;Caso esteja salta para o finalDiv

    jmp proximaIteracao

proximaIteracao:
    
    
    mov si, OFFSET auxArr ;Verifica qual o maior valor do array auxArr menor que HO
    call calcularMenorAux ;Guarda resultado em CX e o index em bl
    
    cmp bl, 0
    
    

    jmp verificardivaux

calcularMenorAux:
    
    mov cx, ax          ;Passa o valor de ax para cx (valor anterior)
    mov ax, [SI]        ;Passa o valor do array para ax
    
    add si, 2           ;Incrementa SI (+2 por causa de ser 16bits)
    
    mov bl,bh           ;Passa o valor de bh para bl (index anterior)
    inc bh              ;Incrementa o valor do array para ax
    
    mov bl, HO          ;Passa HO para os lower bits do bx
    cmp ax, bx          ;Compara ax com HO
    jb calcularMenorAux ;Caso HO seja maior que ax(valor do array) passa para proximo elmento do array
    
    ret                 ;Caso contrario volta para a funcao anterior com o numero do array em cx

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
    
    mov si, offset arrRaiz
    
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
    
    mov si, offset CCArr

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
    mov si, offset CCArr
    mov soma, 0
    xor cx,cx 
    xor dx,dx 
    xor ax,ax 

checkDigit1: 
    xor ax,ax 
    dec bl                 ;bl começa a 10 e e decrementado ate 2            ;posiçao do array igual a do ch
    mov al, bl              ;move o bl para o ax para multiplicar
    mov dl, [si]
    inc si            ;move o algarismo na posiçao do si para o dl
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
    mov si, offset CCArr
    add si, cx       
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
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    mov dx, offset msgInvalido     ;imprime a string msgInvalido
    mov ah, 9
    int 21h 
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado 
    jmp cc


CCFim:
    call clearScreen 
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx         
    mov dx, offset msgValido     ;imprime a string msgValido   
    mov ah, 9h
    int 21h    
    xor ax,ax
    mov ah, 01h      ; Servico para receber um caractere do teclado
    int 21h          ; Captura o caractere digitado 
    jmp start
    
    

;-------------------------------------------------------------------------------------------------------------------

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
    lea dx, msgInvalido     ;imprime a string msgInvalido
    mov ah, 09h
    int 21h
    mov ah,00h
    int 16h
    jmp NIF

NIFValido:
    call clearScreen
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