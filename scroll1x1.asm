#import "common/invoke.asm"
#import "common/mem.asm"
#importonce
.filenamespace c64lib

/*
 * Stack parameters (order of pushing):
 * screenAddress PTR
 * textAddress PTR
 * textPtr WORD
 */
.macro @scroll1x1(tempZero1) {
  .assert "tempZero1 must be a zero page address", tempZero1 <= 255, true

  invokeStackBegin(returnPtr)
  pullParamW(scrollPtr)
  pullParamW(textPtr)
  pullParamW(screenPtr)
  // shift text to left
  copyFast(screenPtr, tempZero1, 2)
  ldy #$00
shiftText:
  iny
  lda (tempZero1), y
  dey
  sta (tempZero1), y
  iny
  cpy #39
  bne shiftText
  // place next char
  copyFast(scrollPtr, tempZero1, 2)
  ldy #$00
  lda (tempZero1), y
  cmp #$ff
  bne placeChar
  copyFast(textPtr, scrollPtr, 2)
  copyFast(scrollPtr, tempZero1, 2)
  lda (tempZero1), y
placeChar:
  sta lastChar
  add16(39, screenPtr)
  copyFast(screenPtr, tempZero1, 2)
  lda screenPtr
  ldy #$00
  sta (tempZero1), y
  invokeStackEnd(returnPtr)
  rts
  // local variables
  returnPtr: .word 0
  scrollPtr: .word 0
  textPtr:   .word 0
  screenPtr: .word 0
  lastChar:  .byte 0
}
