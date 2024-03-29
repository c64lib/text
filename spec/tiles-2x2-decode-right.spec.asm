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
#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem-global.asm"
#import "common/lib/invoke-global.asm"

sfspec: init_spec()

  describe("_t2_decodeScreenRight")

  it("even row for 0,0"); {
    beforeTest()
    // given
    // when
    jsr _t2_decodeScreenRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedScreenEven
  }

  it("odd row for 0.5,0"); {
    beforeTest()
    //given
    c64lib_set16($0080, x)
    c64lib_set16($0000, y)
    // when
    jsr _t2_decodeScreenRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedScreenOdd
  }

  it("even row for 1,0"); {
    beforeTest()
    //given
    c64lib_set16($0100, x)
    c64lib_set16($0000, y)
    // when
    jsr _t2_decodeScreenRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedScreenEven1
  }

  it("odd row for 1.5,0"); {
    beforeTest()
    //given
    c64lib_set16($0180, x)
    c64lib_set16($0000, y)
    // when
    jsr _t2_decodeScreenRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedScreenOdd1
  }


finish_spec()

* = * "Data"
x: .byte 0, 0
y: .byte 0, 0
width: .word 0
temp: .word 0
mapOffsetsLo: .fill 256, 0
mapOffsetsHi: .fill 256, 0
mapDefinitionPtr: .byte <mapDefinition, >mapDefinition
.align $400
testScreenData: {
  .fill 1024, 0
}
.print "tsd=" + testScreenData

mapDefinition:
  //    "00000111112222233333344"
  .fill 19,4; .byte 1,2,1
  .fill 19,4; .byte 2,2,2
  .fill 19,4; .byte 3,2,3
  .fill 19,4; .byte 0,2,3
  .fill 19,4; .byte 1,2,3
  .fill 19,4; .byte 1,1,3
  .fill 19,4; .byte 1,2,3
  .fill 19,4; .byte 1,3,3
  .fill 19,4; .byte 1,2,3
  .fill 19,4; .byte 1,2,3
  .fill 19,4; .byte 1,2,3

tileDefinition0: .text "*1q75"; .fill 251, 0 // +0
tileDefinition1: .text ",2w86"; .fill 251, 0 // +256
tileDefinition2: .text "+3e96"; .fill 251, 0 // +512
tileDefinition3: .text "-4r05"; .fill 251, 0 // +768
tileColors: .byte 10,11,12,13; .fill 252, 0
mapWidth: .byte 22
mapHeight: .byte 11
z0: .byte 251
z1: .byte 253

.print "mapDefinition=$" + toHexString(mapDefinition, 4)
.print "mapDefinitionLO=" + <mapDefinition
.print "mapDefinitionHI=" + >mapDefinition

.namespace c64lib {
  .var @cfg = Tile2Config()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = testScreenData/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 22
  .eval @cfg.x = x
  .eval @cfg.y = y
  .eval @cfg.mapDefinitionPtr = mapDefinitionPtr
  .eval @cfg.mapOffsetsLo = mapOffsetsLo
  .eval @cfg.mapOffsetsHi = mapOffsetsHi
  .eval @cfg.tileDefinition = tileDefinition0
  .eval @cfg.tileColors = tileColors
  .eval @cfg.width = mapWidth
  .eval @cfg.height = mapHeight
  .eval @cfg.z0 = z0
}

expectedScreenEven: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................8"
  .text ".......................................0"
  .text ".......................................,"
  .text ".......................................-"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................2"
  .text ".......................................4"
  .text "........................................"
  .text "........................................"
}

expectedScreenOdd: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................1"
  .text ".......................................3"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................q"
  .text ".......................................e"
  .text "........................................"
  .text "........................................"
}

expectedScreenEven1: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................2"
  .text ".......................................4"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................8"
  .text ".......................................0"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................w"
  .text ".......................................r"
  .text ".......................................w"
  .text ".......................................r"
  .text "........................................"
  .text "........................................"
}

expectedScreenOdd1: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text ".......................................1"
  .text ".......................................3"
  .text ".......................................q"
  .text ".......................................e"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text ".......................................7"
  .text ".......................................9"
  .text "........................................"
  .text "........................................"
}

_t2_initMapOffsets:     .namespace c64lib { _t2_initMapOffsets(@cfg); rts }
_t2_decodeScreenRight:  .namespace c64lib { _t2_decodeScreenRight(@cfg, 0); rts }

.macro beforeTest() {
  c64lib_set16($0000, x)
  c64lib_set16($0000, y)
  c64lib_pushParamW(testScreenData)
  lda #'.'
  jsr fillScreen
  jsr _t2_initMapOffsets
}

fillScreen:
              #import "common/lib/sub/fill-screen.asm"
