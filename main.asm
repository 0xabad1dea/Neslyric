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
    sta XScroll
    sta YScroll
  
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
    lda #$c1 ; fill
.loop:          ; counting to 1024 (256x4)
    sta $2007
    inx
    bne .loop
    dey
    bne .loop

DoMainLogo:
    lda #$0
    ldy #0
    clc    

LogoLoop:
    ldx #$21
    stx $2006
    ldx TitleOffsetTable,y
    stx $2006 
    ldx #$00    
    ldx #0
.LoadLogo1:
    sta $2007
    inx
    adc #1
	;clc
    cpx #16
    bne .LoadLogo1
    iny

    cpy	#8
    bne LogoLoop
; laaaaaaaaazyyy
	ldy #0
	lda #127
LogoLoop2:
    ldx #$22
    stx $2006
    ldx TitleOffsetTable,y
    stx $2006 
    ldx #$00    
    ldx #0
.LoadLogo1:
    sta $2007
    inx
    adc #1
    ;clc
    cpx #16
    bne .LoadLogo1
    iny

    cpy	#8
    bne LogoLoop2
    
    lda #$23
	sta $2006
	lda #$20
	sta $2006
	ldx #0
LoadTempText:
	lda TemporaryText,x
	sta $2007
	inx
	cpx #32
	bne LoadTempText

    
    
	lda #0 ; whoops this is kind of important, no wonder i was getting sprite
		   ; corruption with a letter q flying around...

    
.DoClearNSF:
; and other stuff. 
    sta $0000,x	; zp - used by ppmck and our variables
    sta $0200,x ; used by ppmck
    sta $0300,x ; sprite page
    inx
    cpx #255
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


	
;;;; we have switched from mmc1 to mmc3 :>
; here is some IRQ magic

	lda #$40
	sta $4017
	cli

; bg colors
    lda #$23
    sta $2006
    lda #$C0
    sta $2006
    ldx #0
    lda #%00000000
.LoadColors: ; 

    sta $2007
    inx
    cpx #64
    bne .LoadColors
    

    
;;;; set up sprite zero for rescroll trigger
	ldx #0
.ZeroSprite:
    lda SpritePages,x
    sta $0300,x
    inx
    cpx #$4
    bne .ZeroSprite
	
; derp I can't believe I forgot this

	lda #%10001000 
	sta $2000
	lda #$1A ; no bias
	sta $2001

	
	;; enable mmc3 interrupts
	lda #1
	;sta $E000
	lda #120
	sta $C000
	sta $C001
	lda #1
	sta $e000
	sta $E001
looploop:
	  
;	lda $2002
;	and #%01000000
;	cmp #%01000000
;	beq ScrollNowNowNow
	jmp looploop
	




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
ResumeInit:    

TitleOffsetTable:
    .db $08,$28,$48,$68,$88,$a8,$c8,$e8
TemporaryText:
	.db " This Is Neslyric Version 0.0.1 "
    






	


