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
; Definicoes 
;******************************************************************************
LCD_data	equ		p2			; barramento de dados
LCD_bf		bit		LCD_data.7	; busy flag
LCD_rw		bit		p3.5		; read/write
LCD_en		bit		p3.6		; pino de enable (clock)
LCD_rs		bit		p3.7		; register select

;******************************************************************************
			end
;******************************************************************************
