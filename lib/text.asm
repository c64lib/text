#import "common/lib/invoke.asm"
#import "chipset/lib/vic2.asm"
#importonce
.filenamespace c64lib

.macro @incText(text, count) {
  // thank you Alex Goldblat!
  .fill text.size(), text.charAt(i) + count
}
.assert "incText", { incText("ab", 1)} , { .text "bc" }

// Hosted subroutines

/*
 * Display text pointed by text pointer at screen (memory) location pointed by screen location pointer.
 * Text must be ended with $FF and shall not be longer than 256 characters.
 *
 * Stack parameters (order of pushing)
 *  text pointer LO
 *  text pointer HI
 *  screen location pointer LO
 *  screen location pointer HI
 */
.macro _outText() {
  invokeStackBegin(returnPtr)
  pullParamW(storeText + 1)
  pullParamW(loadText + 1)
  
  ldx #$00
loop:
  loadText: lda $FFFF, x
  cmp #$FF
  beq end
  storeText: sta $FFFF, x
  inx
  bne loop
end:
  invokeStackEnd(returnPtr)
  rts
  // local variables
  returnPtr: .word 0
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
.macro _outHex() {
    invokeStackBegin(returnPtr)
    pullParamW(storeHex + 1)   // IN: screen location ptr
    pullParamW(loadByte + 1)   // IN: byte ptr
    
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
