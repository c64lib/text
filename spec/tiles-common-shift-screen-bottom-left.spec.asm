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
  describe("_t2_shiftScreenLeftBottom")

  it("shifts screen to the left/bottom by 1 byte"); {
    jsr shiftScreenLeftBottom

    assert_bytes_equal 1000: testScreenData: expectedScreenData_leftBottom
  }

finish_spec()

* = * "Data"
.namespace c64lib {
  .var @cfg = TileCommonConfig()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 4096/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 23
}

.align $400
testScreenData: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text "1234567890123456789012345678901234567890"
}
.print "test data address = " + testScreenData

expectedScreenData_leftBottom: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "1234567890123456789012345678901234567890"
}
shiftScreenLeftBottom:  .namespace c64lib { _t2_shiftScreenLeftBottom(@cfg, 0); rts }
