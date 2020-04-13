#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem-global.asm"

sfspec: init_spec()

  describe("decodeTile")

  it("tile for row 0"); {
    beforeTest()
    // given
    ldx #0
    ldy #0
    // when
    jsr decodeTile
    // then
    assert_a_equal #0
    // given
    ldx #1
    ldy #0
    // when
    jsr decodeTile
    // then
    assert_a_equal #1
    //given
    ldx #24
    ldy #0
    // when
    jsr decodeTile
    // then
    assert_a_equal #24
  }

  it("tile for row 1"); {
    beforeTest();
    // given
    ldx #0
    ldy #1
    // when
    jsr decodeTile
    // then
    assert_a_equal #25
    // given
    ldx #1
    ldy #1
    // when
    jsr decodeTile
    // then
    assert_a_equal #26
    // given
    ldx #24
    ldy #1
    // when
    jsr decodeTile
    // then
    assert_a_equal #49
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

mapDefinition:
  .fill 250, i

mapWidth: .byte 25
mapHeight: .byte 10

.print "mapDefinition=$" + toHexString(mapDefinition, 4)
.print "mapDefinitionLO=" + <mapDefinition
.print "mapDefinitionHI=" + >mapDefinition

.namespace c64lib {
  .var @cfg = Tile2Config()
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 22
  .eval @cfg.x = x
  .eval @cfg.y = y
  .eval @cfg.mapDefinitionPtr = mapDefinitionPtr
  .eval @cfg.mapOffsetsLo = mapOffsetsLo
  .eval @cfg.mapOffsetsHi = mapOffsetsHi
  .eval @cfg.width = mapWidth
  .eval @cfg.height = mapHeight
}

_t2_initMapOffsets:     .namespace c64lib { _t2_initMapOffsets(@cfg); rts }
decodeTile:  .namespace c64lib { decodeTile(@cfg); rts }

.macro beforeTest() {
  c64lib_set16($0000, x)
  c64lib_set16($0000, y)
  jsr _t2_initMapOffsets
}
