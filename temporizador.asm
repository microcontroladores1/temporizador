; Pratica de temporizador.
; Programador: Fco Edno
;
; Temporizador para acionamento de lampada UV.

;******************************************************************************
; Diretivas ASSEMBLY
;******************************************************************************
$NOMOD51
$INCLUDE (89S52.MCU)

;******************************************************************************
; DEFINICOES 
;******************************************************************************
LCD_data	equ		p2			; barramento de dados
LCD_bf		bit		LCD_data.7	; busy flag
LCD_rs		bit		p3.5		; register select
LCD_rw		bit		p3.6		; read/write
LCD_en		bit		p3.7		; pino de enable (clock)

;******************************************************************************
; MACROS
;******************************************************************************

;******************************************************************************
; INTERRUPT VECTOR ENTRY-POINT
;******************************************************************************
			org		0000h		; reset entry point
			ljmp	_main

;******************************************************************************
; MAIN
;******************************************************************************
			org		0030h		; addres right above interrupt vectors
_main:		mov		sp, #30h

			acall	LCD_init	; inicializa o LCD

_start:		mov		a, #'a'
			acall	LCD_sendData

			ajmp	$

;******************************************************************************
; SUB-ROTINAS
;******************************************************************************

;------------------------------------------------------------------------------
; LCD_delay
;------------------------------------------------------------------------------
; Da um delay de 30ms
;------------------------------------------------------------------------------
LCD_delay:	
			mov		r2, #200

_back:		mov		r3, #250
			djnz	r3, $

			djnz	r2, _back

			ret
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; LCD_busy
;------------------------------------------------------------------------------
; Faz a leitura da Busy Flag e do contador de enderecos do LCD.
; - Retorna: A busy flag na C, e o valor do contador de endereco no ACC.
;------------------------------------------------------------------------------
LCD_busy:	
			clr		LCD_en			; prepara para o pulso alto no clock
			clr		LCD_rs			; seleciona registrador de comando
			setb	LCD_rw			; define operacao de leitura

			mov		LCD_data, #0FFh	; coloca a porta como entrada.

			setb	LCD_en			; pulso alto no pino de clock
			clr		LCD_en

			mov		c, LCD_bf		; faz a leitura da busy flag
			mov		a, LCD_data		; faz a leitura do endereco
			clr		acc.7			; remove a busy flag do endereco

			ret
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; LCD_wait
;------------------------------------------------------------------------------
; Aguarda ate que a ultima instrucao seja processada pelo LCD.
;------------------------------------------------------------------------------
LCD_wait:
			clr		LCD_en			; prepara para um pulso alto de cock
			clr		LCD_rs			; seleciona registrador de comandos
			setb	LCD_rw			; define operacao de leitura

			setb	LCD_bf			; define a bf como i/p

			setb	LCD_en			; pulso de clock alto

_checkBF:	clr		LCD_en			; apos a finalizacao do pulso alto, leio BF
			setb	LCD_en			; ja prepara para habilitar a leitura

			jb		LCD_bf, _checkBF; se BF=1, check denovo
			
			ret
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; LCD_sendCmd
;------------------------------------------------------------------------------
; Envia tleza comando contido no ACC para o LCD.
;------------------------------------------------------------------------------
LCD_sendCmd:
			acall	LCD_wait	; aguarda a busy flag ser liberada

			clr		LCD_en		; en = 0, para fazer um pulso de clock alto

			clr		LCD_rs		; selecion registro de instrucao
			clr		LCD_rw		; seleciona operacao de escrita
			mov		LCD_data, a	; envia o comando contido no ACC

			setb	LCD_en		; pulso de clock alto
			clr		LCD_en

			ret
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; LCD_init
;------------------------------------------------------------------------------
; Inicializa o LCD.
;------------------------------------------------------------------------------
LCD_init:
			mov		LCD_data, #30h		
			;acall	LCD_delay

			mov		LCD_data, #30h		
			;acall	LCD_delay

			mov		LCD_data, #30h		
			;acall	LCD_delay

			; Function Set: 0 0 1 DL N F - -
			; - 8-bit Interface (DL = 1)
			; - 2 lines (N = 1)
			; - Font 5x8 (F = 0)
			mov		a, #38h
			acall	LCD_sendCmd

			; Display On/Off: 0 0 0 0 1 D C B
			; - Liga display (D = 1)
			; - Desliga cursor (C = 0)
			; - Sem Blink (B = 0)
			mov		a, #0Dh
			acall	LCD_sendCmd

			; Display Clear: 0 0 0 0 0 0 0 1
			mov		a, #01h
			acall	LCD_sendCmd

			; Entry Mode Set: 0 0 0 0 0 1 I/D S
			; - Auto incremento (I/D = 1)
			; - Nao acompanha o shift (S = 0)
			mov		a, #06h
			acall	LCD_sendCmd

			ret
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; LCD_sendData
;------------------------------------------------------------------------------
; Envia o dado contido no ACC para ser impresso.
;------------------------------------------------------------------------------
LCD_sendData:
			acall	LCD_wait		; aguarda o LCD ficar pronto
			
			clr		LCD_en			; prepara para pulso alto

			setb	LCD_rs			; seleciona registrador de dados
			clr		LCD_rw			; define operacao de escrita

			mov		LCD_data, a		; envia o valor contido no ACC

			setb	LCD_en			; pulso alto
			clr		LCD_en

			ret
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; LCD_sendSTR
;------------------------------------------------------------------------------
; Envia a string cujo inicio esta determinada no ACC para o LCD.
;------------------------------------------------------------------------------
LCD_sendSTR:
			ret
;------------------------------------------------------------------------------

;******************************************************************************
			end
;******************************************************************************
