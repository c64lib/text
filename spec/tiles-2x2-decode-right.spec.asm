#import "../lib/tiles-2x2-global.asm"
#import "64spec/lib/64spec.asm"
#import "common/lib/mem.asm"
#import "common/lib/invoke-global.asm"

sfspec: init_spec()
  describe("_t2_decodeScreenRight")
  
  it("a [40,3] map sets three offsets"); {
    beforeTest()

    assert_bytes_equal 1000: testScreenData: expectedScreen0
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
mapDefinition:
  //    "00000111112222233333344"
  .text ""
  .text ""
  .text ""
  .text ""
  .text ""
  .text ""
  .text ""
  .text ""
  .text ""
  .text ""
tileDefinition0: .text "abcd"; .fill 252, 0
tileDefinition1: .text "1234"; .fill 252, 0
tileDefinition2: .text "mnop"; .fill 252, 0
tileDefinition3: .text "7890"; .fill 252, 0
tileColors: .byte 0,1,2,3; .fill 252, 0
mapWidth: .byte 22
mapHeight: .byte 11
z0: .byte 251
z1: .byte 253

testScreenData: {
  .fill 1000, 0
}

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
  .eval @cfg.tileDefinition = tileDefinition0
  .eval @cfg.tileColors = tileColors
  .eval @cfg.width = mapWidth
  .eval @cfg.height = mapHeight
  .eval @cfg.z0 = z0
}

expectedScreen0: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
}

expectedColorRam0: {
  //    "0000011111222223333344444555556666677777"
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
  .text "........................................" 
}

_t2_initMapOffsets:     .namespace c64lib { _t2_initMapOffsets(@cfg, width, temp); rts }
_t2_decodeScreenRight:  .namespace c64lib { _t2_decodeScreenRight(@cfg, testScreenData); rts }
_t2_decodeColorRight:   .namespace c64lib { _t2_decodeColorRight(@cfg, testScreenData); rts }

.macro beforeTest() {
  c64lib_pushParamW(testScreenData)
  lda #'.'
  jsr fillScreen
}

fillScreen:
              #import "common/lib/sub/fill-screen.asm"
