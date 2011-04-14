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

BGPalettes:
; mikutetocolors
	.db $30,$25,$2b,$00 ; white pink green gray
	.db $00,$01,$02,$03
	.db $04,$05,$06,$07
	.db $08,$09,$0a,$0b
SPRPalettes:
; mikutetocolors
	.db $30,$25,$2b,$00 ; white pink green gray
	.db $00,$01,$02,$03
	.db $04,$05,$06,$07
	.db $08,$09,$0a,$0b
	
	
	
	
	
; remember that the ZeroSprite needs to appear exactly once in each frame,
; at the point where you want the splitscreen to happen. Every sprite bank needs
; a non-empty zeroeth tile for this purpose. I know it's annoying to eat up a 
; tile like that, but it is a bizarre quirk of the NES. Look, Super Mario 
; features so many mushrooms for a reason... 
SpritePages:
            ; y     	; tile		; spec		; x 
ZeroSprite: .db 196-24,	$00,        $00,		8