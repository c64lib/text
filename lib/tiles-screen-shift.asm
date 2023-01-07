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
/*
 * c64lib/text/tiles-screen-shift.asm
 *
 * A library that supports drawing and 4-directional scrolling of 2x2 tile map using text modes
 * of VIC-II. All three text modes are supported.
 *
 * Color limitations:
 *  - color RAM is configured per 2x2 tile
 *
 * Author:    Maciej Malecki
 * License:   MIT
 * (c):       2019
 * GIT repo:  https://github.com/c64lib/text
 */
#import "common/lib/common.asm"
#import "tiles-common.asm"
#importonce
.filenamespace c64lib

// ==== Private stuff ====
.macro _t2_shiftScreenLeft(cfg, pageFrom, pageTo) {
  // cost ???
  // size ???
  .var screenFromAddress = _t2_screenAddress(cfg, pageFrom)
  .var screenToAddress = _t2_screenAddress(cfg, pageTo)
  ldx #0                              //(2)/2
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
      lda screenFromAddress + y*40 + 1, x //(4)/3
      sta screenToAddress + y*40, x     //(4)/3
    }
    inx                               //(2)/1
    cpx #39                           //(2)/2
  fbne(loop)
}

.macro _t2_shiftScreenLeftTop(cfg, page) {
  // cost 548cc / 8153cc
  // size 13b   / 160b
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0                                      // 2-2
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow - 1; y++) {
      lda screenAddress + (y + 1)*40 + 1, x   // 4-3
      sta screenAddress + y*40, x             // 4-3
    }
    inx                                       // 2-1
    cpx #39                                   // 2-2
  fbne(loop)                                  // 2-2 / 5-5
}

.macro _t2_shiftScreenTop(cfg, page) {
  // cost 40 * 8 (=320) cycles per line; 7680 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0
  loop:
    .for(var y = cfg.startRow + 1; y <= cfg.endRow; y++) {
      lda screenAddress + y*40, x
      sta screenAddress + (y - 1)*40, x
    }
    inx
    cpx #40
  fbne(loop)
}

.macro _t2_shiftScreenRightTop(cfg, page) {
  // cost 548cc / 8153cc
  // size 13b   / 160b
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #39                                     // 2-2
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow - 1; y++) {
      lda screenAddress + (y + 1)*40 - 1, x   // 4-3
      sta screenAddress + y*40, x             // 4-3
    }
    dex                                       // 2-1
    cpx #0                                    // 2-2
  fbne(loop)                                  // 2-2 / 5-5
}

.macro _t2_shiftScreenRight(cfg, page) {
  // cost 39 * 8 (=312) cycles per line; 7800 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #39
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
      lda screenAddress + y*40 - 1, x
      sta screenAddress + y*40, x
    }
    dex
    cpx #0
  fbne(loop)
}

.macro _t2_shiftScreenRightBottom(cfg, page) {
  // cost 39 * 8 (=312) cycles per line; 7800 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #39
  loop:
    .for(var y = cfg.endRow - 1; y >= cfg.startRow; y--) {
      lda screenAddress + y*40 - 1, x
      sta screenAddress + (y + 1)*40, x
    }
    dex
    cpx #0
  fbne(loop)
}

.macro _t2_shiftScreenBottom(cfg, page) {
  // cost 40 * 8 (=320) cycles per line; 7680 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0
  loop:
    .for(var y = cfg.endRow - 1; y >= cfg.startRow; y--) {
      lda screenAddress + y*40, x
      sta screenAddress + (y + 1)*40, x
    }
    inx
    cpx #40
  fbne(loop)
}

.macro _t2_shiftScreenLeftBottom(cfg, page) {
  // cost 39 * 8 (=312) cycles per line; 7800 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0
  loop:
    .for(var y = cfg.endRow - 1; y >= cfg.startRow; y--) {
      lda screenAddress + y*40 + 1, x
      sta screenAddress + (y + 1)*40, x
    }
    inx
    cpx #39
  fbne(loop)
}
