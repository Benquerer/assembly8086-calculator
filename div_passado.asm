include 'emu8086.inc'

org 100h

.data
teste db "Errou!Brinks$"
resto dw 0
tamanhodiv db 0
tamanhonum db 0
aux1 db 0
aux2 db 0
quociente dw 0 
Fnum db 0 ;flag do numerador para o caso de ser negativo
Fd db 0 ; flag do divisor para o caso de ser negativo
enter db 0ah,0dh,"$"
askNumerador db "Insira o valor do numerador: $"
askDivisor db "Insira o valor do divisor:$"
mostraResultado db "O resultado da divisao:$"
msgErro db "Nao e possivel dividir pelos parametros$"
mostraResto db "O resto e:$"
numeradorarray db 5 dup 0
divisorarray db 5 dup 0 


.code 
Inicio:
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    xor si,si
    xor di,di

    lea dx,askNumerador ;
    mov ah,09h          ;ESCREVE NO ECRA A STRING A PEDIR VALORES
    int 21h             ;

    mov si,0
    lea si,numeradorarray 



NumCondition:        ; RECEBE O VALOR
    mov ah,01h
    int 21h

    cmp al,45            ;quando encontra o -
    je CHECKmenos1 
    cmp al,13          ; enter
    je continuar 
    cmp al,48
    je CHECK0na1pos1
    cmp al,49   ;///////////////////////////////
    jb erro     ;VERIFICA SE O VALOR INTRODUZIDO
    cmp al,57   ;ESTA ENTRE 1 E 9
    ja erro     ;///////////////////////////////
    jmp lerNumerador

CHECK0na1pos1:
    cmp cl,0
    je erro
    jmp lerNumerador
    CHECKmenos1:   ; o cl esta a contar o tamanho ou seja ele so aceita quando esta na 1 pos ou seja cl=0
    cmp cl,0
    jne erro
    mov Fnum,1       ;ativa a flagnum para quando o numerador e negativo
    jmp NumCondition

lerNumerador:
    sub al,30h; conversao do hexa de ascii para hexa dos numeros de 0a9
    mov [si],al ;armazena o numero recebido no numeradorarray na posicao si(por default comeca a 0)  
    inc cl  ; incrementa o tamanho do numerador
    inc si  ; incrementa o pointer do array para selecionar as posicoes
    cmp cl,4 ; compara se o valor do numerador tem 5 algorismos, conta 0,1,2,3,4 
    ja continuar
    jmp NumCondition 

continuar:
    mov tamanhonum,cl ; guarda o tamanho do numerador

    lea dx,enter      ;faz um enter    
    mov ah,09h
    int 21h     
    lea dx,enter      ;faz outro enter/tambem se pode dizer q imprime uma string q faz um paragrafo    
    mov ah,09h
    int 21h

    lea dx,askDivisor   ;mostra no ecra a string askDivisor           
    mov ah,09h          
    int 21h

    mov di,0
    lea di,divisorarray ;carrega o array
        
    xor cx,cx

DivCondition:
    mov ah,01h         ;recebe um input
    int 21h
    cmp al,45          ;verifica se e um sinal -
    je CHECKmenos2 
    cmp al,13          ; verifica se e um enter
    je sair2
    cmp al,48
    je CHECK0na1pos2
    cmp al,49   ;///////////////////////////////
    jb erro     ;VERIFICA SE O VALOR INTRODUZIDO
    cmp al,57   ;ESTA ENTRE 1 E 9
    ja erro     ;///////////////////////////////
    jmp lerDivisor

CHECK0na1pos2:
    cmp cl,0
    je erro
    jmp lerDivisor

;O ERRO ESTA AQUI PARA NAO COLIDIR COM PARTES DO CODIGO DO CALCULO, 
;IGNORAR O POSICIONAMENTO QUANDO REALIZAr A LEITURA DO CODIGO
erro:
cls:
    pusha         ; 
    mov ah, 0x00  ;
    mov al, 0x03  ; text mode 80x25 16 colours
    int 0x10
    popa
    ;ret

    lea dx, msgErro   ;imprime a string msgErro
    mov ah, 09h
    int 21h 
    
    lea dx,enter      ;imprime a string Enter q faz um paragrafo
    mov ah,09h
    int 21h
    
    jmp Inicio

CHECKmenos2:        ;vai verificar se o sinal - introduzido funcemina
    cmp cl,0            ;ve se o menos foi introduzido na primeira pos
    jne erro            ;caso nao vai pro erro
    mov Fd,1            ;ativa a flagdivisor =1
    jmp DivCondition    

    mov di,0
    lea di,divisorarray 

lerDivisor:
    sub al,30h         ;converte do valor em ascii 
    mov [di],al        ;armazena no array divisor array na pos [di] que comeca a 0 por default
    inc di             ;incrementa o pointer para correr o array se necessario
    inc cl   ;o cl vai registar o tamanho ao  incrementar
    cmp cl,4 ; verifica quando o divisor chega ao max de 5 algarismos
    ja sair2
    jmp DivCondition 

Negativo:
    mov dl,45     ;45 equivale ao sinal - em ascii
    mov ah,02h
    int 21h       ;este interruptor imprime o que estiver no dl aka o sinal menos
    jmp Continua2 ;isto esta aqui embora seja apenas invocado na linha 163


sair2:    
    mov tamanhodiv,cl ; armazena o cl no tamanho
    lea dx,enter          
    mov ah,09h
    int 21h     
    lea dx,enter      ;faz uns enters por questoes esteticas    
    mov ah,09h
    int 21h  
        
    lea dx,mostraResultado ; mostra no ecra a string mostraResultado               
    mov ah,09h          
    int 21h

    mov ah,Fd
    mov dh,Fnum
    cmp dh,ah   ;compara as duas flags se ambos os numeros forem positivos ou negativos nao ha problema
    jne Negativo; se so 1 for negativo entao tem q se adicionar o sinal - no quociente

Continua2:
    xor dx,dx   ; uns quantos xors pra ter a certeza q nao ha valores com lixo
    xor cx,cx
    xor di,di
    xor si,si
    xor ax,ax
    lea di,divisorarray        ;da load aos arrays
    lea si,numeradorarray                
                                                                                    ;di=[pos]
                                                                                ;pos=012
CriaDiv:                        ;cria o divisor | EXEMPLO DE LOGICA:imagina q o div e 143
    MUL ch                      ;al*ch q na primeira volta fica 0x0 | 0x0                       |al*ch=1*10=10|al*ch=140
    mov bl,[di]                 ;bl =[di] di comeca a 0 ou seja fica com a primeira pos |bl=1   |bl=4         |bl=3
    mov ch,10                   ;ch=10                                                  |ch=10  |ch=10        |ch=10
    ADD al,bl                   ;al = al +bl                                            |al= 0+1|al=10+4=14   |al=140+3=143
    inc di                      ;vai filtrando o array                                  |di=0+1 |di=1+1       |di=2+1=3
    inc cl                      ;calcula o tamanho                                      |cl=0+1 |cl=1+1       |cl=2+1=3
    cmp cl,tamanhodiv           ;compara para garantir q nao ultrapassa o tamanho       |                     |chegou ao tamanho
    jne CriaDiv                 ;enquanto nao percorrer o array todo volta
    mov bl,al ; o divisor na sua totalidade passa para bl
                                                                                        
    xor dx,dx  ;Clears so pra ter a certeza
    xor ax,ax  ;sao recorrentes ao longo do codigo
    xor cx,cx
    mov cl,tamanhonum ; cx = tamanhonum
    Compara:          ;vai ver se o num>=div se nao for da erro para isso vai ter q se criar o num semelhante ao criaDIV
    MUL dh            ;al*10
    mov dl,[si]
    mov dh,10
    add al,dl         ;al=al+dl
    inc si 
    dec cl         
    cmp cl,0
    ja Compara
    cmp al,bl      ;se for abaixo da erro pq nao da pra fazer o calculo
    jb erro



    mov ax,0        ;limpa se os registers !
    mov cx,0
    mov si,0
    lea si,numeradorarray

CriaNum:       ;cria o num inicial ate o necessario por exemplo se for 1000/2 ele so vai selecionar o 10 inicialmente
    Mul dh         ;dh =10
    mov dl,[si]
    add al,dl
    inc si
    inc cl         ;vai vendo o tamanho
    cmp al,bl      ;e aqui q esta a dif, a partir do momento em q o num e maior q o div continua para o calculo
    jb CriaNum
    ;aux1=numerador parcial
    xor ch,ch

Calculo:         ;bl=divisor , al=numerador ate agr selecionado
    CMP al,0
    je Calculo2
    sub al,bl           ;faz as ch subtracoes
    inc ch              ;quociente=ch
    cmp al,bl           ;ve se o resto ja e inferior ao divisor se nao continua a subtrair
    jae calculo 
    mov dl,ch           ;quociente passa para dl
    mov aux1,al         ;aux1 =resto, precisamos disto pq neste interruptor pra alem de imprimir o dl faz com que o al=dl
    add dl,030h         ;adiciona 30h para o valor equivaler ao codigo ascii dos numeros
    mov ah,02h    ;imprime o quociente
    int 21h
    mov al,aux1  ; al=restoatual
    xor ah,ah    ; limpa o ah por precaucao
    jmp salto

Calculo2:
    mov dl,0           ;quociente passa para dl
    mov aux1,al         ;aux1 =resto, precisamos disto pq neste interruptor pra alem de imprimir o dl faz com que o al=dl
    add dl,48         ;adiciona 30h para o valor equivaler ao codigo ascii dos numeros
    mov ah,02h    ;imprime o quociente
    int 21h
    mov al,aux1  ; al=restoatual
    xor ah,ah    ; limpa o ah por precaucao

salto: 
    mov dh,10
    xor ch,ch ; e necessario resetar o quociente
    BaixaNum:        ;baixa um num
    cmp cl,tamanhonum ;ve se o cl ja chegou ao fim do array caso sim ja nao baixa nada
    je final
    mov bh,[si]       ;o bh vai guardar o valor do array na pos si que depende de quantos ciclos foram necessarios na linha 206
    MUL dh            ;dh=10, logo alx10
    inc cl            ;para ver quando chega ao tamanho maximo
    inc si            ;inc uma pos no array para no prox baixanum ja dar
    ADD al,bh         ;al = al+bh
    jmp Calculo       ;salta para o calculo denovo 
                              
final:
    mov aux1,al                              
    lea dx,enter
    mov ah,09h
    int 21h
    lea dx,enter
    mov ah,09h
    int 21h

    lea dx,mostraresto
    int 21h
    mov ah,0
    mov al,aux1

    Call print_num_uns


DEFINE_PRINT_NUM_UNS ;

;PROBLEMA: por alguma razao os arrays nao estao a devolver os valores direito
; o pseudocodigo foi testado em papel e funcionou enquanto que em codigo ocorrem bugs

