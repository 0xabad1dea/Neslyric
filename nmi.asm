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


;;;;
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

;;;;



