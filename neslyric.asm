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
    .ineschr    2   ; The number of 8KB CHR files
    .inesmir    0   ; Yeah don't touch this.
    .inesmap    4   ; mmc3, do not touch
    
    
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
    .bank 5
    .org $0000
    .incbin "res/font.chr" ; 2, 3
	

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
    

 NMI_Routine:

    .include "nmi.asm"

 .org  $FFA0
NMIResume:

;========== this chunk needs to be .orged at $FFA0 in every high bank

Music:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;   lda Timer
 ;   and #1
 ;   cmp #1
 ;   bne NMIEnd



NMIEnd:

;;;;
	; temporary, until loading scroll values from events
	; get this - I had this earlier in NMI and it didn't work (the ld/in/st) - 
	; what the heck, Nintendo? Why do you do this to me?
	ldx XScroll
	inx
	stx XScroll
	ldx YScroll
	inx
	stx YScroll

; scrolling
    lda XScroll
    sta $2005
    lda #0
    sta $2005

	jsr	$8084 ;sound_driver_start     

	rti
	
  	
IRQ_Routine:		; sprite 0 interrupt will go here


	lda #%00000000
	sta $8000
	lda #5 ; alphabet
	sta $8001

	lda #$2A ; color bias
	sta $2001
	;lda #$20
	;sta $2006
	lda #0
	sta $2005
	sta $2005

	lda #$23
	sta $2006
    lda #$00
    sta $2006
	sta $e000
	sta $e001

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
XScroll			.rs 1	; ''
YScroll			.rs 1	; ''






