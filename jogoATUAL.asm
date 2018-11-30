;telaCredito; Projeto final aula Laboratório de Arquitetura de Computadores 2
; Jogo - Assembly Kong
; Desenvolvido por Leticia Amaral da Cunha 
;				   R.A.: 628190
; Desenvolvimento iniciado em 03/11/2018

INCLUDE Irvine32.inc

.data
telaTitulo	 BYTE 219d, " _______  ______ ______ _______ _______ ______  _       _     _     _     _ _______ _______ _______" , 0ah, 0dh 
			 BYTE 219d, "(_______)/ _____) _____|_______|_______|____  \(_)     | |   | |   (_)   | (_______|_______|_______)", 0ah, 0dh
			 BYTE 219d, " _______( (____( (____  _____   _  _  _ ____)  )_      | |___| |    _____| |_     _ _     _ _   ___ ", 0ah, 0dh
			 BYTE 219d, "|  ___  |\____ \\____ \|  ___) | ||_|| |  __  (| |     |_____  |   |  _   _) |   | | |   | | | (_  |", 0ah, 0dh
			 BYTE 219d, "| |   | |_____) )____) ) |_____| |   | | |__)  ) |_____ _____| |   | |  \ \| |___| | |   | | |___) |", 0ah, 0dh
			 BYTE 219d, "|_|   |_(______(______/|_______)_|   |_|______/|_______|_______|   |_|   \_)\_____/|_|   |_|\_____/ ", 0
telaEscolha	 BYTE 219d, "                                       1 - Inicar Jogo", 0ah, 0dh
			 BYTE 219d, "                                       2 - Instrucoes", 0ah, 0dh
			 BYTE 219d, "                                       3 - Creditos", 0ah, 0dh
			 BYTE 219d, "                                       4 - Sair", 0ah, 0dh
			 BYTE 219d, "                                  Aperte espaco para selecionar", 0

telaInstrucoes BYTE 219d, "                            OI OI OI, TUDO BEM?", 0ah, 0dh
			   BYTE 219d, "                            EU SOU O JOGUINHO ASSEMBLY KONG", 0ah, 0dh
			   BYTE 219d, "                            POR ENQUANTO EU SO TENHO ISSO MESMO", 0ah, 0dh
			   BYTE 219d, "                            AGORA TCHAU", 0

telaCreditos BYTE 219d, "    JOGO FEITO TODO POR LELE DA CUNHA : )", 0 

mapaJogo	BYTE 219d,"00000000000000000000000000000000000000000000000000000000000000000000000H0",0ah, 0dh
			BYTE 219d,"00000000000000000000000000000000000000000000000000000000000000000000000H0",0ah, 0dh
			BYTE 219d,"                                                                       H",0ah, 0dh
			BYTE 219d," ",0ah, 0dh
			BYTE 219d,"                         0H0000000000000000000000000000000000000000000000000000000000000000000000000",0ah, 0dh
			BYTE 219d,"                         0H0000000000000000000000000000000000000000000000000000000000000000000000000",0ah, 0dh
			BYTE 219d,"                          H",0ah, 0dh
			BYTE 219d," ",0ah, 0dh
			BYTE 219d,"00000000000000000000000000000000000000000000000000000000000000000000000H0",0ah, 0dh
			BYTE 219d,"00000000000000000000000000000000000000000000000000000000000000000000000H0",0ah, 0dh
			BYTE 219d,"                                                                       H",0ah, 0dh
			BYTE 219d," ",0ah, 0dh
			BYTE 219d,"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",0ah, 0dh
			BYTE 219d,"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",0

telaDerrota BYTE "Mas voce perdeu hein?!", 0

contornoHori BYTE 223d, 0
contornoVert BYTE 219d, 0

indiceMenu BYTE 0
posicaoIndice BYTE 13, 38

desenhoProt BYTE 0ceh																											; Desenho do Protagonista 
posicaoProt BYTE 18, 2																											; Posicao do Protagonista na tela

desenhoBarril BYTE 040h																											; Desenho Barril 
posicaoBarril BYTE 18, 99																										; Posicao Barril

pontos BYTE "Pontuacao: ",0
numeroPontos BYTE 0
vidas BYTE "Vidas: ", 0
numeroVidas BYTE 3

testeBarril WORD 0


.code

MoveBarril PROC
		mov eax, yellow
		call SetTextColor			;Escreve o barril de amarelo na tela
		mov dh, [posicaoBarril]		;Posicao na Linha do Barril
		mov dl, [posicaoBarril+1]	;Posicao na Coluna do Barril
		call Gotoxy					;Posiciona o cursor na posicao do Barril
		mov al, 20h
		call WriteChar				;Apaga a escrita passada do barril na tela
		dec [posicaoBarril+1]		;Decrementa posicao de Coluna do barril (move para esquerda)
		mov dl, [posicaoBarril+1]	;Atualiza posicao de Coluna do barril 
		call Gotoxy
		mov al, 40h
		call WriteChar				;Escreve barril na tela 
		ret
MoveBarril ENDP


AndarProtagonista PROC
		mov dh,	[posicaoProt]		;Posicao na Linha do protagonista
		mov dl, [posicaoProt+1]		;Posicao na Coluna do protagonista
		call Gotoxy	
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206					;Escreve o caracter que representa o protagonista 
		call WriteChar  
	andar:
		cmp [testeBarril], 010000
		jne leitura
		mov [testeBarril], 0
		call MoveBarril

		mov al, [posicaoProt]
		cmp [posicaoBarril], al
		jne leitura
		mov al, posicaoProt+1
		cmp [posicaoBarril+1], al
		jne leitura
		mov dh, 24
		mov dl, 30
		call GotoXY
		mov edx, OFFSET[telaDerrota]
		call WriteString

	leitura:
		call ReadKey				;Le entreda do usuario
		inc [testeBarril]
		cmp al, 61h
		je esq						;Se 'a' move o personagem para a esquerda
		cmp al, 77h
		je pulo						;Se 'w' realiza o pulo ou subida de escada 
		cmp al, 64h
		je dir						;Se 'd' move o personagem para a direita
		cmp al, 73h
		jne andar					;Se 's' realiza a descida da escada 
		
	;Descida das escadas

		mov dh, [posicaoProt]
		mov dl, [posicaoProt+1]
		call GotoXY					;Posiciona o cursor na posicao do protagonista
		mov al, 20h
		call WriteChar				;Apaga o que esta escrito na posicao do protagonista
		cmp dl, 27					;Se na coluna da escada pode continuar o teste
		jne outradesce				;Se nao for deve saber se esta na coluna da outra escada
		cmp dh, 10					;Se na linha da escada tambem a descida deve ocorrer 
		je queda
	outradesce:
		cmp dl, 72					;Se na coluna das duas outras escadas pode continuar
		jne andar					;Se em nenhuma das escadas deve ler outra entrada do usuario
		cmp dh, 6					;Se na escada superior pode continuar
		je queda
		cmp dh,14					;Se na escada inferior pode continuar
		je queda
		jmp andar					;Se em nenhuma das escadas deve ler outra entrada do usuario

	;Movimentacao para direita

	dir:						
		mov dh,	[posicaoProt]		;Posicao na Linha do protagonista
		mov dl, [posicaoProt+1]		;Posicao na Coluna do protagonista
		cmp dl, 100					;Se no limite direito do mapa deve ler outra entrada do usuario
		je andar
		call Gotoxy					;Posiciona o cursor na posicao atual do Protagonista
		mov al, 20h					
		call WriteChar				;Apaga o que esta escrito na posicao do Protagonista
		inc [posicaoProt+1]			;Adiciona 1 ao indice de posicao na coluna do Protagonista 
		mov dl, [posicaoProt+1]		;Atualiza a posicao do cursor para o Protagonista 
		cmp dl, 74					;Testa se esta na posicao do limite direito da plataforma atual 
		jne andardireita			;Caso nao, deve andar o Protagonista para a direita 
		cmp dh, 6					;Testa se esta na plataforma superior
		je queda					;Deve realizar a queda do protagonista
		cmp dh, 14					;Testa se esta na pataforma inferior 
		je queda					;Deve realizar a queda do protagonista 
	andardireita:
		call Gotoxy
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206					;Atualiza a posicao do Protagonista na tela 
		call WriteChar
		jmp andar					;Le uma nova entrada de teclado do usuario

	;Movimentacao para a esquerda

	esq:
		mov dh,	[posicaoProt]		;Posicao na Linha do protagonista
		mov dl, [posicaoProt+1]		;Posicao na Coluna do protagonista
		cmp dl, 2					;Se no limite esquerdo do mapa deve ler outra entrada do usuario
		je andar
		call Gotoxy					;Posiciona o cursor na posicao atual do Protagonista
		mov al, 20h
		call WriteChar				;Apaga o que esta escrito na posicao do Protagonista
		dec [posicaoProt+1]			;Subtrai 1 ao indice de posicao na coluna do Protagonista
		mov dl, [posicaoProt+1]		;Atualiza a posicao do cursor para o Protagonista 
		cmp dl, 25					;Testa se esta na posicao do limite esquerdo da plataforma atual 
		jne andaresquerda			;Caso nao, deve andar o Protagonista para a esquerda
		cmp dh, 10					;Testa se esta na plataforma do meio
		je queda					;Deve realizar a queda do protagonista
	andaresquerda:
		mov dl, [posicaoProt+1]
		call Gotoxy					;Atualiza a posicao do Protagonista na tela
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206
		call WriteChar
		jmp andar					;Le uma nova entrada de teclado do usuario

	;Queda de plataforma ou descida da escada pelo Protagonista 

	queda:							
		add [posicaoProt],4			;Incrementa a posicao de linha do Protagonista em 4
		mov dh, [posicaoProt]		;Atualiza a posicao do cursor para o Protagonista
		call GotoXY					;Atualiza a posicao do Protagonista na tela 
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206
		call WriteChar
		jmp andar					;Le uma nova entrada de teclado do usuario

	;Pulo ou subida na escada pelo Protagonista 

	pulo:
		mov dh,	[posicaoProt]		;Posicao na Linha do protagonista
		mov dl, [posicaoProt+1]		;Posicao na Coluna do protagonista
		call Gotoxy					;Posiciona o cursor na posicao do protagonista
		mov al, 20h
		call WriteChar				;Apaga o que esta escrito na posicao do Protagonista
		cmp dl, 27					;Se na coluna da escada pode continuar o teste
		jne outrasobe				;Se nao for deve testar se esta na outra coluna 
		cmp dh, 14					;Se esta na linha correta tambem da escada deve subir a plataforma
		je subida
	outrasobe:
		cmp dl, 72					;Se na coluna da escada pode continuar o teste
		jne desce
		cmp dh, 18					;17 pois posicao ja foi decrementada
		je subida
		cmp dh, 10
		jne desce
	subida:
		sub [posicaoProt], 4
		mov dh, [posicaoProt]
		call GotoXY
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206
		call WriteChar
		jmp andar
	desce:
		dec [posicaoProt]
		mov dh, [posicaoProt]
		call Gotoxy
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206
		call WriteChar
		mov eax, 500
		call Delay
		call Gotoxy
		mov al, 20h
		call WriteChar
		inc [posicaoProt]
		mov dh, [posicaoProt]
		call Gotoxy
		mov eax, red				;Escreve o personagem na cor vermelha 
		call SetTextColor
		mov al, 206
		call WriteChar
		jmp andar
AndarProtagonista ENDP

ContagemRegressiva PROC
; CONTAGEM REGRESSIVA
		mov ecx, 3						; Inicio da contagem regressiva
		mov dh, 10						; Definicao da posicao do cursor
		mov dl, 50
		mov ebx, 51						; Numero 3 inicia a contagem
	l1:
		call Gotoxy
		mov al, bl
		call WriteChar					; Imprime o numero da contagem
		mov eax, 1000
		call Delay						; Delay de 1 segundo 
		call Gotoxy
		mov al, 20h						
		call WriteChar					; Apaga o digito que esta na tela
		mov eax, 1000
		call Delay						; Delay de 1 segundo
		dec ebx							; Decrementa o numero da contagem
		loop l1
ContagemRegressiva ENDP

ImprimeMoldura PROC 
; Procedimento que imprime a moldura do jogo na tela
		call Clrscr						;Limpa a tela atual
		mov ecx, 101					;Molduras Horizontais 	
		mov eax, 1
	l1:
		mov edx, 0						;Limpa o valor atual de edx
		mov dh, 1						;Seta o cursor na tela
		mov dl, al
		call GotoXY
		mov edx, OFFSET contornoHori	;passa o caractere para edx
		call WriteString				;escreve na tela
		mov edx, 0						;Limpa o valor atual de edx
		mov dh, 21						;Seta o cursor na tela
		mov dl, al
		call GotoXY
		mov edx, OFFSET contornoHori	;passa o caractere para edx
		call WriteString				;escreve na tela
		inc eax
		loop l1
		
		mov ecx, 20						;Molduras Verticais
		mov eax, 1
	l2:	
		mov edx, 0
		mov dh, al
		mov dl, 0
		call GotoXY
		mov edx, OFFSET contornoVert
		call WriteString
		mov edx, 0
		mov dh, al
		mov dl, 101
		call GotoXY
		mov edx, OFFSET contornoVert
		call WriteString
		inc eax
		loop l2
		ret
ImprimeMoldura ENDP


ImprimeTelas PROC
; Procedimento que altera a tela mostrada na tela 
; Variáveis em uso: TelaTitulo
;					TelaEscolha
;					TelaInstrucoes
;					TelaCreditos
;					indiceMenu
;					PosicaoIndice


	Inicio:
		call ImprimeMoldura
		mov eax, white
		call SetTextColor
		mov dh, 3
		mov dl, 0
		call GotoXY
		mov edx, OFFSET telaTitulo
		call WriteString
		mov dh, 13
		mov dl, 0
		call GotoXY
		mov edx, OFFSET telaEscolha
		call WriteString
		mov dh, [posicaoIndice]
		mov dl, [posicaoIndice+1]
		call Gotoxy
		mov eax, red
		call SetTextColor
		mov al, 3eh
		call WriteChar
	InicioVolta:
		call ReadKey						;Le entrada do usuario
		cmp al, 20h							;Compara com espaco
		je Vai
		cmp al, 77h							;Compara com w
		je Sobe
		cmp al, 73h							;Compara com s
		jne InicioVolta
		cmp indiceMenu, 3					;Testa para saber se e ultima opcao
		je InicioVolta
		mov dh, [posicaoIndice]
		mov dl, [posicaoIndice+1]
		call Gotoxy
		mov al, 20h							;Apaga caracter na posicao antiga
		call WriteChar
		inc [posicaoIndice]					;Altera posicao caracter
		mov dh, [posicaoIndice]
		call Gotoxy							
		mov al, 3eh
		call WriteChar						;Escreve caracter na nova posicao
		inc indiceMenu						;Incrementa o indice de opcoes
		jmp InicioVolta
	Sobe:
		cmp indiceMenu, 0
		je InicioVolta
		mov dh, [posicaoIndice]
		mov dl, [posicaoIndice+1]
		call Gotoxy
		mov al, 20h
		call WriteChar
		dec [posicaoIndice]
		mov dh, [posicaoIndice]
		call Gotoxy
		mov al, 3eh
		call WriteChar
		dec indiceMenu
		jmp InicioVolta
	Vai:
		cmp indiceMenu, 0
		je ImprimeJogo
		cmp indiceMenu, 1
		je ImprimeInstrucoes
		cmp indiceMenu, 2
		je Creditos
		cmp indiceMenu, 3
		exit
	ImprimeJogo:
		mov eax, white
		call SetTextColor
		call ImprimeMoldura
		call ContagemRegressiva
		mov ecx, 101					
		mov eax, 1
	lJogo:
		mov edx, 0					
		mov dh, 3					
		mov dl, al
		call GotoXY
		mov al, 0DFh
		call WriteChar			
		loop lJogo
		mov dh, 2
		mov dl, 5
		call GotoXY
		mov edx, OFFSET pontos
		call WriteString
		mov dh, 2
		mov dl, 17
		call GotoXY
		mov al, [numeroPontos]
		call WriteDec
		mov dh, 2
		mov dl, 80
		call GotoXY
		mov edx, OFFSET vidas
		call WriteString
		mov dh, 2
		mov dl, 87
		call GotoXY
		mov al, [numeroVidas]
		call WriteDec
		mov dh, 7
		mov dl, 0
		call Gotoxy
		mov edx, OFFSET mapaJogo
		call WriteString
		ret
	ImprimeInstrucoes:
		mov eax, white
		call SetTextColor
		call ImprimeMoldura
		mov dh, 6
		mov dl, 0
		call GotoXY
		mov edx, OFFSET telaInstrucoes
		call WriteString
	InstrucoesVolta:
		call ReadKey
		cmp al, 20h
		je Inicio
		jmp InstrucoesVolta
	Creditos:
		mov eax, white
		call SetTextColor
		call ImprimeMoldura
		mov dh, 6
		mov dl, 0
		call Gotoxy
		mov edx, OFFSET telaCreditos
		call WriteString
	CreditosVolta:
		call ReadKey
		cmp al, 20h
		je Inicio
		jmp CreditosVolta
ImprimeTelas ENDP

main PROC	
	
	call ImprimeTelas
	call AndarProtagonista


	exit
main ENDP 
END main
