/*
 * MIT License
 *
 * Copyright (c) 2017-2023 c64lib
 * Copyright (c) 2017-2023 Maciej Małecki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#import "common/lib/invoke.asm"
#import "common/lib/mem.asm"
#importonce
.filenamespace c64lib

/*
 * Stack parameters (order of pushing):
 * screenAddress PTR
 * textAddress PTR
 * textPtr WORD
 */
.macro scroll1x1(tempZero1) {
  .assert "tempZero1 must be a zero page address", tempZero1 <= 255, true
  .print "tempZero1 installed at " + toHexString(tempZero1) + " and " + toHexString(tempZero1 + 1)

  invokeStackBegin(returnPtr)
  pullParamW(scrollPtr)
  pullParamW(textPtr)
  pullParamW(screenPtr)

  // shift text to left
  copyFast(screenPtr, tempZero1, 2)

  #if C64LIB_SPEED_CODE
    ldy #$01
    .for(var i = 0; i < 39; i++) {
      // speed copy of 39 characters
      lda (tempZero1), y
      dey
      sta (tempZero1), y
      iny
      iny
    }
  #else
    ldy #$00
    shiftText:
      iny
      lda (tempZero1), y
      dey
      sta (tempZero1), y
      iny
      cpy #39
    bne shiftText
  #endif

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
  lda lastChar
  ldy #$00
  sta (tempZero1), y
  add16(1, scrollPtr)
  pushParamWInd(scrollPtr)
  invokeStackEnd(returnPtr)
  rts
  // local variables
  returnPtr: .word $ffff
  scrollPtr: .word $ffff
  textPtr:   .word $ffff
  screenPtr: .word $ffff
  lastChar:  .byte $ff
}
