#import "common/lib/invoke.asm"

/*
 * Installs subroutine that prints hex representation of given byte on the screen.
 *
 * Stack parameters (order of pushing):
 *  bytePointerLo
 *  bytePointerHi
 *  screenLocationPointerLo
 *  screenLocationPointerHi
 */
.namespace c64lib {
  outHex: {

  invokeStackBegin(returnPtr)
  pullParamW(storeHex)   // IN: screen location ptr
  pullParamW(loadByte)   // IN: byte ptr

  lda loadByte:$ffff // load byte to process

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
    sta storeHex:$ffff, x
    inx
    rts
  end:

  invokeStackEnd(returnPtr)
  rts
  // local variables
  returnPtr:  .word 0
  hexChars:   .text "0123456789abcdef"
  }
}
