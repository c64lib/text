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
