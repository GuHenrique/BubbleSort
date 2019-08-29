   
; PIC18F452 Configuration Bit Settings

; Assembly source line config statements

#include <P18F452.inc>

; CONFIG1H
  CONFIG  OSC = HS              ; Oscillator Selection bits (HS oscillator)
  CONFIG  OSCS = OFF            ; Oscillator System Clock Switch Enable bit (Oscillator system clock switch option is disabled (main oscillator is source))

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bit (Brown-out Reset disabled)
  CONFIG  BORV = 20             ; Brown-out Reset Voltage bits (VBOR set to 2.0V)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 128           ; Watchdog Timer Postscale Select bits (1:128)

; CONFIG3H
  CONFIG  CCP2MUX = OFF         ; CCP2 Mux bit (CCP2 input/output is multiplexed with RB3)

; CONFIG4L
  CONFIG  STVR = OFF            ; Stack Full/Underflow Reset Enable bit (Stack Full/Underflow will not cause RESET)
  CONFIG  LVP = ON              ; Low Voltage ICSP Enable bit (Low Voltage ICSP enabled)

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000200-001FFFh) not code protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code protected)

; CONFIG5H
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000200-001FFFh) not write protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0001FFh) not write protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000200-001FFFh) not protected from Table Reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from Table Reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from Table Reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from Table Reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0001FFh) not protected from Table Reads executed in other blocks)

    
sTemp1 equ 0X90
sTemp2 equ 0X91

 
    ORG 0x00

    GOTO INIT
 

INIT  
    
    MOVLW 0x80		;MOVE O Valor de 0x80 para o REG DE TRABALHO 
    MOVWF FSR0L		;MOVE O Valor do REG DE TRABALHO para a REG que armazena o Ponteiro
			;Ao executar esse comando ele manda o valor de 0x80 para o REG INDF0

RUN
    MOVF INDF0,W	;MOVE o valor de INFD0 para o REG DE TRABALHO
    MOVWF sTemp1	;MOVE O Valor do REG DE TRABALHO para a Variavel sTemp1
    INCF FSR0L,F	;INCREMENTA mais 1 no Valor do REG
    MOVF INDF0,W	;MOVE o Valor de INFD0 para o REG DE TRABALHO
    SUBWF sTemp1,W	;SUBTRAI O Valor da Variavel sTemp1 do REG DE TRABALHO e salva no  REG DE TRABALHO
    
    BTFSC STATUS,Z	;Testa o BIT do Operação de SUBTRAÇÃO anterior e SE for = 0 pula a proxima linha 
    GOTO TEST_LARGER	;Vai para a função TEST_LARGER

    BTFSS STATUS,C	;Testa o BIT do Operação de SUBTRAÇÃO anterior e SE for = 1 pula a proxima linha 
    GOTO TEST_LARGER
   
    GOTO CHANGE

TEST_LARGER
    BTFSS STATUS,N
    GOTO CHANGE
    GOTO RUN

CHANGE
    MOVF INDF0,W ;Menor no W
    MOVFF sTemp1,INDF0
    DECF FSR0L,F
    MOVWF INDF0
    INCF FSR0L,F
    
    GOTO INIT
    

    END    
