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
#import "64spec/lib/64spec.asm"
#import "../lib/tiles-screen-shift.asm"

sfspec: init_spec()
  describe("_t2_shiftScreenLeft")

  it("shifts screen to the left by 1 byte"); {
    jsr shiftScreenLeft

    assert_bytes_equal 1000: testScreenData: expectedScreenData_left
  }

  describe("_t2_shiftScreenRight")

  it("shifts screen to the right by 1 byte"); {
    jsr shiftScreenRight

    assert_bytes_equal 1000: testScreenData: expectedScreenData_right
  }

  describe("_t2_shiftScreenTop")

  it("shifts screen to the top by 1 byte"); {
    jsr shiftScreenTop

    assert_bytes_equal 1000: testScreenData: expectedScreenData_top
  }

  describe("_t2_shiftScreenBottom")

  it("shifts screen to the bottom by 1 byte"); {
    jsr shiftScreenBottom

    assert_bytes_equal 1000: testScreenData: expectedScreenData_bottom
  }

finish_spec()
.print "test data address = " + testScreenData

* = * "Data"
.namespace c64lib {
  .var @cfg = TileCommonConfig()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 5120/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 23
}

.align $400
testScreenData: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    .fill 40, <(v + i)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
.print "test data address = " + testScreenData

expectedScreenData_left: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    .fill 39, <(v + i + 1)
    .byte <(v + 39)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
expectedScreenData_right: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    .byte <(v + 1)
    .fill 39, <(v + i + 1)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
expectedScreenData_top: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow - 1; y++) {
    .byte <(v + 2)
    .fill 39, <(v + i + 2)
    .eval v++
  }
  .byte <(v + 1)
  .fill 39, <(v + i + 1)
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
expectedScreenData_bottom: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .byte <(v + 2)
  .fill 39, <(v + i + 2)
  .for(var y = cfg.startRow + 1; y <= cfg.endRow; y++) {
    .byte <(v + 2)
    .fill 39, <(v + i + 2)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
shiftScreenLeft:    .namespace c64lib { _t2_shiftScreenLeft(@cfg, 0, 0); rts }
shiftScreenRight:   .namespace c64lib { _t2_shiftScreenRight(@cfg, 0); rts }
shiftScreenTop:     .namespace c64lib { _t2_shiftScreenTop(@cfg, 0); rts }
shiftScreenBottom:  .namespace c64lib { _t2_shiftScreenBottom(@cfg, 0); rts }
