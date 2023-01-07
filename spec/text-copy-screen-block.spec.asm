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
#import "../lib/text-global.asm"

sfspec: init_spec()

    describe("copyScreenBlock")

    it("puts 6x3 block under location (4,3)"); {
        // when
        lda #<block0
        ldx #>block0
        jsr copyScreenBlockTo_4_3
        // then
        assert_bytes_equal 1000: testScreenData: expectedScreenData0
        assert_bytes_equal 1000: testColorRAM: expectedColorRam0
    }

finish_spec()

* = * "Data"

testScreenData: .fill 1000, '.'
testColorRAM: .fill 1000, '.'
colorMap: .byte 10, 12, 14, 1, 3, 5

block0:
    .byte 0, 1, 2, 0, 1, 2
    .byte 3, 4, 5, 3, 4, 5
    .byte 0, 3, 5, 0, 3, 5

expectedScreenData0:
    .fill 40*3, '.'
    .text "...."; .byte 0, 1, 2, 0, 1, 2; .text ".............................." // 3
    .text "...."; .byte 3, 4, 5, 3, 4, 5; .text ".............................." // 4
    .text "...."; .byte 0, 3, 5, 0, 3, 5; .text ".............................." // 5
    .fill 40*19, '.'

expectedColorRam0:
    .fill 40*3, '.'
    .text "...."; .byte 10, 12, 14, 10, 12, 14; .text ".............................." // 3
    .text "...."; .byte 1, 3, 5, 1, 3, 5; .text ".............................." // 4
    .text "...."; .byte 10, 1, 5, 10, 1, 5; .text ".............................." // 5
    .fill 40*19, '.'

copyScreenBlockTo_4_3: c64lib_copyScreenBlock(6, 3, testScreenData + 3*40+4, colorMap, testColorRAM + 3*40+4)
