; --------------------------------------------------
; Library and Configs
; --------------------------------------------------
			#INCLUDE 	<p18f6620.inc>
			
; --------------------------------------------------
; Variables and Definitions
; --------------------------------------------------
loop_cnt1	set			0x00
loop_cnt2	set			0x01
sub_start	set			0x1000

; --------------------------------------------------
; MACRO duplication (frequency 32MHz)
; --------------------------------------------------
dup_NOP		MACRO		kk
			VARIABLE	i
i=0
			WHILE		i<kk
			NOP
i+=1
			ENDW
			ENDM
			
; --------------------------------------------------
; Program start template
; --------------------------------------------------
			ORG			0x00
			GOTO		start
			
			ORG			0x08
			GOTO		ISR_HI				; Emergency STOP operation button
			RETFIE
			
			ORG			0x18
			RETFIE
		
; --------------------------------------------------
; Main Program
; --------------------------------------------------
start		BSF 		RCON,IPEN,A 		; configuring ISR_HI and ISR_LO (INT0 & INT1) as interrupt
			BSF 		INTCON,GIEH,A
			BSF			INTCON,GIEL,A
			BCF 		INTCON,INT0IF,A 
			BSF 		INTCON,INT0IE,A		; enable INT0 for ISR_HI (Interrupt)
			BCF 		INTCON2,INTEDG0,A
			CLRF		TRISC,A				; Set output and input for pins at C,D and E
			CLRF		TRISD,A
			SETF		TRISE,A
			MOVLW		0x0F
			MOVFF		WREG,TRISB
			MOVLW		0x07
			MOVFF		WREG,CMCON
			SETF		LATD,A
			
			;PUMP A
PUMPA		CLRF		ADRESH,A
			CLRF		ADRESL,A
			MOVLW		0x01
			MOVFF		WREG,ADCON0
			MOVLW		0x0C
			MOVFF		WREG,ADCON1
			MOVLW		0xA2
			MOVFF		WREG,ADCON2
			MOVLW		0x08				; acquisition time of 8 * TAD
			MOVWF		PRODL, A			;
			CALL 		TADdelay			; at least 13.36 us for acqusition time
			BSF 		ADCON0,GO,A			; start the conversion
_convertA	BTFSC 		ADCON0,DONE,A		; wait for 12 TAD or just poll for
			BRA 		_convertA			; conversion DONE bit
			MOVLW       0x03				; If ADRESH is = 3, meaning it is dry threshold, ( max resistance )
            CPFSEQ      ADRESH,A
            BRA         SKIPA
            BRA         OPENPUMP1
SKIPA       MOVLW       0x00				; If ADRESH is = 0, meaning it is moist threshold, ( no resistance )
            CPFSEQ      ADRESH, A
            BRA         PUMPB
            BRA         CLOSEPUMP1
CLOSEPUMP1  BCF         LATB,5,A
			BSF			LATD,0,A
            BRA         PUMPB
OPENPUMP1   BSF         LATB,5,A
			BCF			LATD,0,A

			;PUMP B MODE
PUMPB    	CLRF		ADRESH, A			; clear back the ADRES In A/D
			CLRF		ADRESL, A
			MOVLW		0x05
			MOVFF		WREG, ADCON0		; Choose AN1 as the analog input in the current moment
			MOVLW		0x08				; TAD delay for conversion
			MOVWF		PRODL, A
			CALL		TADdelay
			BSF			ADCON0, GO, A
_convertB	BTFSC		ADCON0, DONE, A
			BRA			_convertB
			MOVLW       0x03				; If ADRESH is = 3, meaning it is dry threshold, ( max resistance )
            CPFSEQ      ADRESH, A
            BRA         SKIPB
            BRA         OPENPUMP2
SKIPB       MOVLW       0x00				; If ADRESH is = 0, meaning it is moist threshold, ( no resistance )
            CPFSEQ      ADRESH, A
            BRA         PUMPC
            BRA         CLOSEPUMP2
CLOSEPUMP2  BCF         LATB,6,A
			BSF			LATD,1,A
            BRA         PUMPC
OPENPUMP2   BSF         LATB,6,A
			BCF			LATD,1,A
			BRA			PUMPC

			;PUMP C MODE

PUMPC    	CLRF		ADRESH, A
			CLRF		ADRESL, A
			MOVLW		0x09
			MOVFF		WREG,ADCON0			; Choose AN2 as the analog input ATM for PUMPC check
			MOVLW		0x08				; 8 cycle tad delay to reach the minimum delay conversion
			MOVWF		PRODL, A
			CALL		TADdelay
			BSF			ADCON0,GO,A
_convertC	BTFSC		ADCON0,DONE,A
			BRA			_convertC
			MOVLW       0x03				; Launch pump3 if too dry
            CPFSEQ      ADRESH, A
            BRA         SKIPC
            BRA         OPENPUMP3
SKIPC       MOVLW       0x00				; Turn off pump3 if too moist
            CPFSEQ      ADRESH, A
            BRA         PUMPA
            BRA         CLOSEPUMP3
CLOSEPUMP3  BCF         LATB,7,A
			BSF			LATD,2,A
            BRA         PUMPA
OPENPUMP3   BSF         LATB,7,A
			BCF			LATD,2,A
			BRA			PUMPA
; --------------------------------------------------
; ISR_HI subroutine (when SW1 is pressed, INT0)
; --------------------------------------------------
ISR_HI		BCF			INTCON,INT0IF,A
			CLRF		LATB,A
			SETF		LATD,A
			CALL		DELAY1S
LOOP		BTFSC		PORTE,0,A
			BRA			LOOP
			RETURN


; --------------------------------------------------
; Delay 1 second (32MHz)
; --------------------------------------------------
DELAY1S		MOVLW		D'128'			;160 x 250 = 40,000
			MOVWF		loop_cnt2,A	
AGAIN1		MOVLW		D'250'
			MOVWF		loop_cnt1,A
AGAIN2		dup_NOP		D'247'			;duplication of NOP = 247 + 3(DECFSZ+BRA)
			DECFSZ		loop_cnt1,F,A
			BRA			AGAIN2
			DECFSZ		loop_cnt2,F,A
			BRA			AGAIN1
			NOP
			RETURN
			
; ----------------------------------
; Subroutine for delay of TAD times using TIMER and PRODL
; Assume Freq = 32MHz, 1 TAD = 2 us (64*TOSC)
; ----------------------------------
				ORG		sub_start
TADdelay		MOVLW 	0xC8				; TMR0ON, 8-bit, by pass pre-scale
				MOVWF 	T0CON, A
_nx				MOVLW 	0xF0
				MOVWF 	TMR0L, A
				
				BCF 	INTCON, TMR0IF, A	
_poll			BTFSS 	INTCON, TMR0IF, A	; wait for delay
				BRA 	_poll
				DECFSZ	PRODL, F, A			
				BRA		_nx
				RETURN
		
; ----------------------------------
				END