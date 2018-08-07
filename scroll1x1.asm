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
.macro @scroll1x1() {
  invokeStackBegin(returnPtr)
  pullParamW(ldaPtr + 1)
  copyFast(ldaPtr + 1, staPtr + 1, 2)
  pullParamW(ldaText + 1)
  pullParamW(ldaScreen + 1)
  copyFast(ldaScreen + 1, staScreen + 1, 2)
  inc16(ldaScreen + 1)
  copyFast(staScreen + 1, staLastChar + 1, 2)
  add16(39, staLastChar + 1)
  // shift text to left
  ldx #$00
shiftText:
  ldaScreen: lda $ffff, x
  staScreen: sta $ffff, x
  inx
  cpx #39
  bne shiftText
  // place next char
  ldaPtr: lda $ffff
  cmp #$ff
  bne placeChar
  ldaText: lda $ffff
  staPtr: sta $ffff
placeChar:
  staLastChar: sta $ffff
  invokeStackEnd(returnPtr)
  rts
  // local variables
  returnPtr: .word 0
}
