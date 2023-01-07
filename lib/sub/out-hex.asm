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
