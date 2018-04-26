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
 * hexChars should contain address of list of characters used to display number, 
 * normally it should point to "0123456789abcdef".
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
 * hexChars should contain address of list of characters used to display number, 
 * normally it should point to "0123456789abcdef".
 *
 * USE: A, X
 * MOD: A, X, Y
 */
.macro outAHex(screenLocPointer, hexChars) {
		sta ldx1 + 1 // preserve for second digit
    lsr          // shift right 4 bits
    lsr
    lsr
    lsr
		sta ldx0 + 1 // preserve for first digit
		lda ldx1 + 1 // load second digit
		and #%1111   // clear first digit
		sta ldx1 + 1 // store it again
		jsr ldx0     // display first digit
		jsr ldx1     // display second digit
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
