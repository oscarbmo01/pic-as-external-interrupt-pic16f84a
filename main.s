;-------------------------------------------------------------------------------
; File: main.s
; Author: Oscar Lira Gonzalez
; Device: pic16f84a
; Description: Example of external interrupt used RB0/INT.
; Compilator: pic-as
;-------------------------------------------------------------------------------
    
;-------------------------------------------------------------------------------
; Libraries included	    
;-------------------------------------------------------------------------------
    
PROCESSOR 16F84A
#include <xc.inc>

;-------------------------------------------------------------------------------
; PIC16F84A Configuration Bit Settings
;-------------------------------------------------------------------------------
    
; CONFIG
  CONFIG FOSC = XT              ; Oscillator Selection bits (XT oscillator)
  CONFIG WDTE = OFF		; Watchdog Timer (WDT enabled)
  CONFIG PWRTE = OFF		; Power-up Timer Enable bit (Power-up Timer is disabled)
  CONFIG CP = OFF		; Code Protection bit (Code protection disabled)
  
PSECT resetVec, class=CODE, delta=2, abs
resetVec:
    goto main

PSECT extIntRb0, class=CODE, delta=2
extIntRb0:
    btfss INTF			; external interrupt flag bit test, skip if set		
    goto exitInt
    bsf PORTB, 3		; pin in high mode, on led
    exitInt:
	bcf INTCON, 4		; clear external interrupt flag bit
	retfie			; return from interrupt
	
PSECT code
main:
    bsf	  STATUS, 5		; select bank 1
    
    bsf	  INTCON, 7		; global interrupt enable
    bsf	  INTCON, 4		; external interrupt enable

    bcf	  TRISB, 1		; config pin in output mode
    bcf	  TRISB, 2		
    bcf	  TRISB, 3		
    
    bcf   STATUS, 5		; select bank 0
    
    bcf	  PORTB, 3		; pin in low mode, off led
loop:
    bsf	  PORTB, 1		; pin in high mode, on led
    bsf	  PORTB, 2
    goto  loop			
    
    END resetVec    