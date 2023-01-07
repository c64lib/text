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
