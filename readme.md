Neslyric 8-bit Animation Kit
=============================


![](https://github.com/0xabad1dea/Neslyric/blob/master/neslyric.png?raw=true "Neslyric Unofficial Mascots Miku and Teto")

About
========

Neslyric is a framework written in 6502 assembly for creating simple music videos for the Nintendo Entertainment System. Its mission is to keep the art of authentic 8-bit graphics and music accessible to modern digital artists. It is licensed under Creative Commons 3.0 Attribution and may be used for commercial purposes. If you use Neslyric for financial gain, please make an appropriate monetary donation to the [EFF](http://www.eff.org/) to support technology rights and/or donate some expertise to [Playpower educational software](http://work.playpower.org/w/page/17230499/FrontPage).

Neslyric is mostly written by Melissa Elliott ie 0xabad1dea, with support of the #nesdev IRC channel on efnet. It is tested on an American NTSC NES with the [Powerpak](http://www.retrousb.com/product_info.php?cPath=24&products_id=34) and should also work in all major emulators. It can be assembled on Linux, OSX, and Windows with an open source toolchain included in the tools/ directory.


Event Structure
===============

Neslyric is driven by a simple bytecode describing the screen. Each event struct is 24 bytes, allowing  256 of them (Neslyrics' limit) to fit in one bank. 


	CoolEvent:

	.TimeInSeconds		.db 0 ; 0-255, start of event in integer seconds
	.TimeInSixtieths	.db 0 ; 0-59, fractions of a second from the int
	; ie, one and a half seconds from start would be 1 and 30. 
	; Events need to be in order, or result is undefined. 
	; Do not exceed 59/60ths of a second or result is undefined. 
	
	.StringOneIndex		.db 0 ; index of words to display on top of lyric box
	.StringTwoIndex		.db 0 ; index of words to display on bottom of lyric box
	
	; String indexes are relative to the LyricStrings: label which you should
	; keep in data.asm. Each string should be exactly 32 bytes. Putting index
	; 255 will load a blank string. Keep in mind that on CRT televisions, the
	; two leftmost and rightmost characters may be obscured by fishbowling.
	
	.BackgroundBank		.db 0 ; index of the background image in CHR
	.BackgroundStyle	.db 0 ; 0 for centered, 1 for h-tiled, 2 for v-tiled,
							  ; 3 for four-up
	.BackgroundPalette	.db	0 ; index of 16-byte four palettes for bg, applied
							  ; in vertical stripes of 32px to the 128x128 image
							  ; Index is relative to BGPalettes: label
	.BackgroundScroll	.db 0 ; 0-255, speed of bg movement in px per 60th second
	.BackgroundDirecton .db 0 ; 0 e, 1 w, 2 n, 3 s, 4 ne, 5 nw, 6 se, 7 sw
	.BackgroundFillTile	.db 0 ; Index in CHR bank of a fill tile for tiling modes
							  ; other than 4-up. 
							  
	; Background movement stays in effect until a future event changes it.
	
	.SpriteBank			.db 0 ; index of the sprite page in CHR
	.SpritePalette		.db 0 ; index of 16-byte four palettes for sprites
							  ; relative to SPRPalettes: label
	
	; You get a repeating four-frame animation per event. Each frame is a 255
	; byte structure in standard NES format describing up to 64 sprites.
	; It is recommended that you lay out the frame from 0,0 for easy calculation
	; of location offsets. The frames are calculated from offset SpritePages:
	
	; Neslyric defaults to using 8x16 sprites, so you may use the full page to
	; get a dancing character 64px wide and 128px tall. 
	
	.SpriteSets			.db 0, 0, 0, 0
	.SpriteXOffset		.db 0 ; added to all sprites' x co-ord
	.SpriteYOffset		.db 0 ; added to all sprites' y co-ord
	.SpriteSpeed		.db 0 ; 1-255 how many 60ths/second between each frame.
							  ; Zero is undefined.
							  
							  
	.PPUControl			.db 0 ; For advanced users, written to $2001. You can use
							  ; this to get special color effects. Look up PPU
							  ; mask on the nesdev wiki. If you're not sure, use
							  ; 255 and Neslyric will use its internal default.
							  
	.Reserved			.db 0,0,0,0, ; You may use these for adding your own
									 ; features, but it may break compat
									 ; with future releases of neslyric.
	
	
	





Notes
=====

Miku, Teto, and other Vocaloid "singing robot" characters are © [Yamaha](http://www.vocaloid.com/), and are used in the spirit of fandom which Yamaha widely promotes. 