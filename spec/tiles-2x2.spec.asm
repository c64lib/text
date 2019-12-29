#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem.asm"

sfspec: init_spec()
  describe("_t2_initMapDefinitionOffsets")
  
  it("a [40,2] map sets three offsets"); {
    // given
    lda #40
    sta mapWidth
    lda #2
    sta mapHeight
    // when
    jsr _t2_initMapDefinitionOffsets
    // then
    assert_equal mapDefinitionOffsets : #0 
    assert_equal mapDefinitionOffsets + 1 : #0 
    assert_equal mapDefinitionOffsets + 2 : #40 
    assert_equal mapDefinitionOffsets + 3 : #0 
    assert_equal mapDefinitionOffsets + 4 : #80 
    assert_equal mapDefinitionOffsets + 5 : #0 
  }

finish_spec()

* = * "Data"
x: .word 0
y: .word 0
mapDefinitionPtr: .word 0
width: .word 0
temp: .word 0
mapDefinitionOffsets: .fill 512, 0
mapWidth: .byte 0
mapHeight: .byte 0

.namespace c64lib {
  .var @cfg = Tile2Config()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 5120/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 22
  .eval @cfg.x = x
  .eval @cfg.y = y
  .eval @cfg.mapDefinitionOffsets = mapDefinitionOffsets
  .eval @cfg.width = mapWidth
  .eval @cfg.height = mapHeight
}

_t2_initMapDefinitionOffsets:      .namespace c64lib { _t2_initMapDefinitionOffsets(@cfg, mapDefinitionPtr, width, temp); rts }
