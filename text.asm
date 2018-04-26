#import "chipset/vic2.asm"
#importonce
.filenamespace c64lib

//hexChars:
//	.text "0123456789abcdef"

/*
 * Text pointer ended with $FF and up to 255 characters.
 */
.macro @outText(textPointer, screenMemPointer, xPos, yPos, col) {
	ldx #$00
	lda textPointer, x
loop:
	sta [screenMemPointer + getTextOffset(xPos, yPos)], x
	lda #col
	sta [COLOR_RAM + getTextOffset(xPos, yPos)], x
	inx
	lda textPointer, x
	cmp #$FF
	bne loop
}

/*
 * Outputs one-byte value from given memory location ("bytePointer") at given location "xPos", "yPos" on 
 * screen memory specified by "screenMemPointer" using color "col".
 *
 * MOD: A, X, Y
 */
.macro @outByteHex(bytePointer, screenMemPointer, xPos, yPos, col, hexChars) {
	ldx #$00
	lda bytePointer
	outAHex([screenMemPointer + getTextOffset(xPos, yPos)], hexChars)
	lda #col
	sta [COLOR_RAM + getTextOffset(xPos, yPos)]
	sta [COLOR_RAM + getTextOffset(xPos, yPos) + 1]
}

/*
 * Outputs value stored in accumulator in hexadecimal form at given screen location ("screenLocPointer").
 *
 * USE: A, X
 * MOD: A, X, Y
 */
.macro outAHex(screenLocPointer, hexChars) {
		sta ldx1 + 1
    lsr
    lsr
    lsr
    lsr
		sta ldx0 + 1
		lda ldx1 + 1
		and #%1111
		sta ldx1 + 1
		jsr ldx0
		jsr ldx1
		jmp end
	ldx0:
		ldy #$00
		jmp out
	ldx1:
		ldy #$00
		jmp out
	out:
		lda hexChars, y
		sta screenLocPointer, x
		inx
		rts
	end:
}
