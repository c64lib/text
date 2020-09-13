#import "common/lib/invoke.asm"

/*
 * Installs subroutine that prints hex representation of low nibble of given byte on the screen.
 *
 * Stack parameters (order of pushing):
 *  bytePointerLo
 *  bytePointerHi
 *  screenLocationPointerLo
 *  screenLocationPointerHi
 */
.namespace c64lib {
  outHexNibble: {
  invokeStackBegin(returnPtr)

  pullParamW(storeHex)   // IN: screen location ptr
  pullParamW(loadByte)   // IN: byte ptr
    
  lda loadByte:$ffff // load byte to process
  and #%00001111   // clear first digit
  tay
  lda hexChars, y
  sta storeHex:$ffff
              
  invokeStackEnd(returnPtr)
  rts
  
  // local variables
  returnPtr:  .word 0
  hexChars:   .text "0123456789abcdef"
  }
}
