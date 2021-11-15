#import "common/lib/invoke.asm"
#import "chipset/lib/vic2.asm"
#importonce
.filenamespace c64lib

.macro incText(text, count) {
  // thank you Alex Goldblat!
  .fill text.size(), text.charAt(i) + count
}
.assert "incText", { incText("ab", 1)} , { .text "bc" }

// Hosted subroutines
.macro outHexNibbleOfs(charsetOffset) {
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
  hexChars:   incText("0123456789abcdef", charsetOffset)
}
