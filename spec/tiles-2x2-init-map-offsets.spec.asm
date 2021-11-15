#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem.asm"

sfspec: init_spec()
  describe("_t2_initMapDefinitionOffsets")

  it("a [40,3] map sets three offsets"); {
    // given
    lda #40
    sta mapWidth
    lda #3
    sta mapHeight
    // when
    jsr _t2_initMapOffsets
    // then
    assert_equal mapOffsetsLo : #<mapDefinition
    assert_equal mapOffsetsHi : #>mapDefinition
    assert_equal mapOffsetsLo + 1 : #<(mapDefinition + 40)
    assert_equal mapOffsetsHi + 1 : #>(mapDefinition + 40)
    assert_equal mapOffsetsLo + 2 : #<(mapDefinition + 80)
    assert_equal mapOffsetsHi + 2 : #>(mapDefinition + 80)
  }

finish_spec()

* = * "Data"
x: .word 0
y: .word 0
width: .word 0
temp: .word 0
mapOffsetsLo: .fill 256, 0
mapOffsetsHi: .fill 256, 0
mapDefinitionPtr: .byte <mapDefinition, >mapDefinition
mapDefinition: .fill 400, 0
mapWidth: .byte 0
mapHeight: .byte 0
z0: .byte 251
z1: .byte 253

.print "mapDefinition=$" + toHexString(mapDefinition, 4)

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
  .eval @cfg.width = mapWidth
  .eval @cfg.height = mapHeight
  .eval @cfg.z0 = z0
}

_t2_initMapOffsets:      .namespace c64lib { _t2_initMapOffsets(@cfg); rts }
