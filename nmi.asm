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


 ; loading sprites.... dma-gic

 	lda #3
	sta $4014


    lda #%00000000
	sta $8000
	lda #1 ; logo
	sta $8001

	;; enable mmc3 interrupts
	lda #1
	sta $E000
	lda #193
	sta $C000
	sta $C001
	lda #1
	sta $e000
	sta $E001

    ldx Timer
    inx
    stx Timer
    cpx #60
    beq .ResetTimer
    

    
    
    

;;;;; game mode jumping to approp. nmi

    jmp NMIResume
    


.ResetTimer:
    lda #0
    sta Timer
    ldx SecondsTimer
    inx
    stx SecondsTimer
    ;cpx #60
    ;bne .OutOfLineStage
    sta SecondsTimer
    jmp NMIResume

;;;;



