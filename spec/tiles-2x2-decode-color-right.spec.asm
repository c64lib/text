#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem-global.asm"
#import "common/lib/invoke-global.asm"

sfspec: init_spec()

  describe("_t2_decodeColorRight")

  it("even column for 0,0"); {
    beforeTest()
    // given
    // when
    jsr _t2_decodeColorRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedColorRam1
  }

  it("odd column for 0.5,0"); {
    beforeTest()
    // given
    c64lib_set16($0080, x)
    c64lib_set16($0000, y)
    // when
    jsr _t2_decodeColorRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedColorRam2
  }

  it("even column for 1,0"); {
    beforeTest()
    // given
    c64lib_set16($0100, x)
    c64lib_set16($0000, y)
    // when
    jsr _t2_decodeColorRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedColorRam2
  }

  it("odd column for 1.5,0"); {
    beforeTest()
    // given
    c64lib_set16($0180, x)
    c64lib_set16($0000, y)
    // when
    jsr _t2_decodeColorRight
    // then
    assert_bytes_equal 1000: testScreenData: expectedColorRam3
  }

finish_spec()

.macro beforeTest() {
  c64lib_set16($0000, x)
  c64lib_set16($0000, y)
  c64lib_pushParamW(testScreenData)
  lda #'.'
  jsr fillScreen
  jsr _t2_initMapOffsets
}

* = * "Data"
x: .byte 0, 0
y: .byte 0, 0
width: .word 0
temp: .word 0
mapOffsetsLo: .fill 256, 0
mapOffsetsHi: .fill 256, 0
mapDefinitionPtr: .byte <mapDefinition, >mapDefinition
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
  .fill 19,4; .byte 1,2,1

tileDefinition0: .text "*1q75"; .fill 251, 0 // +0
tileDefinition1: .text ",2w86"; .fill 251, 0 // +256
tileDefinition2: .text "+3e96"; .fill 251, 0 // +512
tileDefinition3: .text "-4r05"; .fill 251, 0 // +768
tileColors: .byte 10,11,12,13; .fill 252, 0
mapWidth: .byte 22
mapHeight: .byte 11
z0: .byte 251
z1: .byte 253

testScreenData: {
  .fill 1000, 0
}

.print "mapDefinition=$" + toHexString(mapDefinition, 4)
.print "mapDefinitionLO=" + <mapDefinition
.print "mapDefinitionHI=" + >mapDefinition

.namespace c64lib {
  .var @cfg = Tile2Config()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 5120/1024
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

expectedColorRam1: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 10
  .text "......................................."; .byte 10
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "........................................"
  .text "........................................"
}

expectedColorRam2: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "........................................"
  .text "........................................"
}

expectedColorRam3: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................"
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "......................................."; .byte 12
  .text "......................................."; .byte 12
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 13
  .text "......................................."; .byte 11
  .text "......................................."; .byte 11
  .text "........................................"
  .text "........................................"
}

_t2_initMapOffsets:     .namespace c64lib { _t2_initMapOffsets(@cfg); rts }
_t2_decodeColorRight:   .namespace c64lib { _t2_decodeColorRight(@cfg, testScreenData); rts }

fillScreen:
              #import "common/lib/sub/fill-screen.asm"
