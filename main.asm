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

;;;; reset -- hardwired final prg bank


Reset_Routine:
; fixing stack stuff
	cld

	sei
	ldx #$ff
	txs

.WaitV:	

	lda	$2002
	bpl	.WaitV
	ldx	#$00    ; kill graphics
	stx	$2000
	stx	$2001



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    lda #0
    sta Timer
    sta SecondsTimer
  
    lda #$3F ; palette stuffing
    sta $2006
    lda #$00
    sta $2006
    
    ldx #$00
.LoadPal:
    lda BGPalettes,x
    sta $2007
    inx
    cpx #$20
    bne .LoadPal
    
.ClearName:     ; filling the background with... nothing
    lda #$20
    sta $2006
    lda #$40
    sta $2006


    ldy #4
    ldx #0 
    lda #0
.loop:          ; counting to 1024 (256x4)
    sta $2007
    inx
    bne .loop
    dey
    bne .loop
    
    ldx #0
.DoClearNSF:

    sta $0000,x
    sta $0200,x
    inx
    cpx #202
    bne .DoClearNSF    
    
    ; this code came from nullsleep	
	; *** CLEAR SOUND REGISTERS ***
	lda #$00		; clear all the sound registers by setting
	ldx #$00		; everything to 0 in the Clear_Sound loop
.Clear_Sound:
	sta $4000,x		; store accumulator at $4000 offset by x
	inx			; increment x
	cpx #$0F		; compare x to $0F
	bne .Clear_Sound		; branch back to Clear_Sound if x != $0F

	lda #$10		; load accumulator with $10
	sta $4010		; store accumulator in $4010
	lda #$00		; load accumulator with 0
	sta $4011		; clear these 3 registers that are 
	sta $4012		; associated with the delta modulation
	sta $4013		; channel of the NES
	
	; *** ENABLE SOUND CHANNELS ***
	lda #%00001111		; enable all sound channels except
	sta $4015		; the delta modulation channel
	
	; *** RESET FRAME COUNTER AND CLOCK DIVIDER ***
	lda #$C0		; synchronize the sound playback routine 
	sta $4017		; to the internal timing of the NES
	
    lda #0
    ldx #0

	jsr	$8080 ;sound_init 
	
    lda #0  ; set scroll (none)
    sta $2005
    sta $2005	

; derp I can't believe I forgot this

	lda #%10001000 
	sta $2000
	lda #$1A ; no bias
	sta $2001
	
;;;; setting up mmc1

;;;; control
    lda #%00011110
    sta $8000
    lsr a
    sta $8000
    lsr a
    sta $8000
    lsr a
    sta $8000
    lsr a
    sta $8000
    
;;;; setting sprite bank to frame1
    lda #0
    sta $c000
    lsr a
    sta $c000
    lsr a
    sta $c000
    lsr a
    sta $c000
    lsr a
    sta $c000	
	

ResetExtended: 

.looploop:
	jmp .looploop




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
ResumeInit:    
    






	


