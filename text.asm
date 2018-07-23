#import "common/invoke.asm"
#import "chipset/vic2.asm"
#importonce
.filenamespace c64lib

/*
 * Text pointer ended with $FF and up to 255 characters.
 * TODO (mmalecki) this shouldn't be implemented like this, it is waste of memory. It should be installable macro that can be then called with jsr
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
 * Installs subroutine that prints hex representation of given byte on the screen.
 *
 * Stack parameters (order of pushing):
 *  bytePointerLo
 *  bytePointerHi
 *  screenLocationPointerLo
 *  screenLocationPointerHi
 */
.macro @outHex() {
    invokeStackBegin(returnPtr)
    pullWordParam(storeHex + 1)   // IN: screen location ptr
    pullWordParam(loadByte + 1)   // IN: byte ptr
    
    loadByte: lda $ffff // load byte to process
    
    ldx #$00
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
    storeHex: sta $ffff, x
    inx
    rts
  end:
    invokeStackEnd(returnPtr)
    rts
  // local variables
  returnPtr:  .word 0
  hexChars:   .text "0123456789abcdef"
}
