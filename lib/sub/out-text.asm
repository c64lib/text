#import "common/lib/invoke.asm"

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
.namespace c64lib {
  outText: {

  invokeStackBegin(returnPtr)
  pullParamW(storeText)
  pullParamW(loadText)

  ldx #$00
  loop:
    lda loadText:$ffff, x
    cmp #$ff
    beq end
    sta storeText:$ffff, x
    inx
  bne loop
  end:

  invokeStackEnd(returnPtr)
  rts
  // local variables
  returnPtr: .word 0
  }
}
