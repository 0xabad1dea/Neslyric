;                                                                       
;                                  _/                      _/            
;   _/_/_/      _/_/      _/_/_/  _/  _/    _/  _/  _/_/        _/_/_/   
;  _/    _/  _/_/_/_/  _/_/      _/  _/    _/  _/_/      _/  _/          
; _/    _/  _/            _/_/  _/  _/    _/  _/        _/  _/           
;_/    _/    _/_/_/  _/_/_/    _/    _/_/_/  _/        _/    _/_/_/      
;                                       _/                               
;                                  _/_/                         
; neslyric 8-bit animation framework
; creative commons attribution
; by 0xabad1dea 2011



; INES header
    .inesprg    2   ; don't touch unless you're taking off every zig
    .ineschr    1   ; The number of 8KB CHR files
    .inesmir    0   ; Yeah don't touch this.
    .inesmap    1   ; mmc1, do not touch
    
    
;------------------------------------------------;
;---- bank usage record -------------------------;
; 0  0 $8000 the NSF
; 1  0 $a000 data.asm
; 2  0 $c000 events.asm
; 3  0 $e000 nmi.asm $f000 main.asm 
; ---- chr ----
; 4.0 miku and teto logo
; 4.1 font
    

;;;; ---------- music bank
    .bank	0
    .org	$8000
    .incbin "res/popipo.nsf"  
    
;;;; ---------- graphics banks
; the first graphics bank starts numerically after the last prg bank

	.bank 4
	.org $0000
    .incbin "res/miku-teto.chr" ; 0, 1
	

;;;; ---------- Reset Bank (final prg bank), runs first
	.bank 3
	.org $f000
    .include "main.asm"
    
    
;;;; ---------- data bank

    .bank 1
    .org $A000
    .include "data.asm"
   
    
;;;; ---------- event bank
    .bank 2
    .org $c000
    .include "events.asm" 


;;;; ---------- nmi, a part of this balanced breakfast
    .bank 3
    .org $e000
    



   ; .include "nmi.asm"
PostNMI:
 .org  $FFD0
 NMI_Routine:
NMIResume:
;========== this chunk needs to be .orged at $FFD0 in every high bank
; no scroll
    lda #0
    sta $2005
    sta $2005
Music:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;   lda Timer
 ;   and #1
 ;   cmp #1
 ;   bne NMIEnd

	jsr	$8084 ;sound_driver_start     

NMIEnd:

	rti
	
  	
IRQ_Routine:		; sprite 0 interrupt will go here
	rti
	
	
	.org	$FFFA           ; vectors
	.dw		NMI_Routine
	.dw		Reset_Routine
	.dw		IRQ_Routine
   

    
;##############################################################################
; variables, zp
    .rsset $001B ; start the reserve counter past the nsf's greedy usage
Timer       	.rs 1   ; fractions of a second (every NMI)
SecondsTimer    .rs 1   ; increments when Timer hits 60   
Tmp				.rs 1	; what it says on the tin






