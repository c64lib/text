#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem.asm"

sfspec: init_spec()
  describe("_t2_initMapDefinitionOffsets")
  
  it("a [40,2] map sets three offsets"); {
    // given
    lda #40
    sta mapWidth
    lda #3
    sta mapHeight
    // when
    jsr _t2_initMapDefinitionOffsets
    // then
    assert_equal mapOffsetsLo : #<mapDefinition
    assert_equal mapOffsetsHi : #>mapDefinition
    assert_equal mapOffsetsLo + 1 : #(<mapDefinition + 40)
    assert_equal mapOffsetsHi + 1 : #(>mapDefinition + 0) 
    assert_equal mapOffsetsLo + 2 : #(<mapDefinition + 80)
    assert_equal mapOffsetsHi + 2 : #(>mapDefinition + 0)
    
    _print_int8 mapOffsetsHi + 0
  }

finish_spec()

* = * "Data"
x: .word 0
y: .word 0
width: .word 0
temp: .word 0
mapOffsetsLo: .fill 256, 0
mapOffsetsHi: .fill 256, 0
mapDefinition: .fill 400, 0
mapWidth: .byte 0
mapHeight: .byte 0

.print toHexString(mapDefinition)

.namespace c64lib {
  .var @cfg = Tile2Config()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 5120/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 22
  .eval @cfg.x = x
  .eval @cfg.y = y
  .eval @cfg.mapDefinition = mapDefinition
  .eval @cfg.mapOffsetsLo = mapOffsetsLo
  .eval @cfg.mapOffsetsHi = mapOffsetsHi
  .eval @cfg.width = mapWidth
  .eval @cfg.height = mapHeight
}

_t2_initMapDefinitionOffsets:      .namespace c64lib { _t2_initMapDefinitionOffsets(@cfg, width, temp); rts }
