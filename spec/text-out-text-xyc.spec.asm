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
#import "common/lib/invoke-global.asm"
#import "../lib/text-global.asm"

sfspec: init_spec()

    describe("outTextXYC")

    it("prints text and color under (4,3)"); {
        // when
        c64lib_pushParamW(testData)
        ldx #4
        ldy #3
        lda #LIGHT_BLUE
        jsr outTextXYC
        // then
        assert_bytes_equal 1000: testScreenData: expectedScreenData0
        assert_bytes_equal 1000: testColorRAM: expectedColorRam0
    }

finish_spec()

* = * "Data"

testData: .text "bez wegla nie ma a8i"; .byte $ff
testScreenData: .fill 1000, '.'
testColorRAM: .fill 1000, '.'

expectedScreenData0:
    .fill 40*3, '.'
    .text "...."; .text "bez wegla nie ma a8i"; .text "................"
    .fill 40*21, '.'

expectedColorRam0:
    .fill 40*3, '.'
    .text "...."; .fill 20, LIGHT_BLUE; .text "................"
    .fill 40*21, '.'

outTextXYC: c64lib_outTextXYC(testScreenData, testColorRAM)