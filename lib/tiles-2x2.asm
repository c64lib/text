#import "tiles-common.asm" 
#import "common/lib/math.asm"
#import "common/lib/mem.asm"

#importonce 
.filenamespace c64lib 

/*
 * Config record for 2x2 tile scrollable playfield.
 */
.struct Tile2Config {
  // start text row of the tiled playfield, values 0..23
  startRow,
  // end text row of the tiled playfield, values 1..24
  endRow,
  // vic 2 bank 0..3
  bank,
  // page number (0..15) of page 0 (1024 bytes) for double buffering
  page0,
  // page number (0..15) of page 1 (1024 bytes) for double buffering
  page1,
  // address (8 or 16 bit) for X position of top left corner (2b), 1st byte - tile position, 2nd byte - sub tile position
  x,
  // address (8 or 16 bit) for Y position of top left corner (2b), 1st byte - tile position, 2nd byte - sub tile position
  y,
  // address (8 or 16 bit) of playfield width in tiles (1 byte)
  width,
  // address (8 or 16 bit) of playfield height (1 byte)
  height,
  // address (8 or 16 bit) for tile definitions (1kb); tiles are encoded in 4x256b banks, each bank storing one char of
  // the tile: top left is bank 0, top right is bank 1, bottom left is bank 2 and bottom right is bank 3
  tileDefinition,
  // address (8 or 16 bit) for tile colors (256b)
  tileColors,
  // address (8 or 16 bit) for map definition (width * height) bytes
  mapDefinitionPtr,
  // address (8 or 16 bit) for display phase counter
  phase,
  // ---- zero page mandatory variables
  // general purpose zero page accumulators for indirect addressing, each accumulator takes two bytes from zero page
  z0,
  z1,
  z2,
  z3,
  // ---- precalculated buffers
  // 16 bit address of lo part of map rows
  mapOffsetsLo,  
  // 16 bit address of hi part of map rows
  mapOffsetsHi
}

.function toTileCommonConfig(tile2Config) {
  .var tileCommonCfg = TileCommonConfig()
  .eval tileCommonCfg.startRow = tile2Config.startRow
  .eval tileCommonCfg.endRow = tile2Config.endRow
  .eval tileCommonCfg.bank = tile2Config.bank
  .eval tileCommonCfg.page0 = tile2Config.page0
  .eval tileCommonCfg.page1 = tile2Config.page1
  .eval tileCommonCfg.x = tile2Config.x
  .eval tileCommonCfg.y = tile2Config.y
  .return tileCommonCfg
}

.macro tile2Init(cfg) {
  _t2_validate(cfg)
  
  _t2_initMapDefinitionOffsets(cfg, width, temp)
 
  lda #$00
  sta cfg.phase
  
  jmp end
    // local variables
    width: .word 0
    temp: .word 0
  
  end:
}

/* 
 * initialize mapOffsetsLo and mapOffsetsHi buffers
 *
 * Mod: A, X, Y
 */
.macro _t2_initMapDefinitionOffsets(cfg, width, temp) {
  cld
  copy16 cfg.mapDefinitionPtr : temp
  copy8 cfg.width : width
  set8 #0 : width + 1
  ldx cfg.height
  ldy #0

  loop:
    lda temp
    sta cfg.mapOffsetsLo, y
    lda temp + 1
    sta cfg.mapOffsetsHi, y
    add16 width : temp
    iny
    dex
  bne loop
}

.macro _t2_decodeScreenRight(cfg, page) {
  .var mapOffsetsLo = cfg.z0
  .var mapOffsetsHi = cfg.z1
  .var tileDefinitionLo = cfg.z2
  .var tileDefinitionHi = cfg.z3
  
  .for (var y = cfg.startRow; y <= cfg.endRow; y++) {
  }
}

.macro _t2_decodeColorRight(cfg, colorPage) {
}

.macro _t2_validate(tile2Config) {
  .assert "startRow must be smaller than endRow", tile2Config.startRow < tile2Config.endRow, true
  .assert "z0 must be defined on zero page", tile2Config.z0 < 254, true
  .assert "z1 must be defined on zero page", tile2Config.z1 < 254, true
  .assert "z2 must be defined on zero page", tile2Config.z2 < 254, true
  .assert "z3 must be defined on zero page", tile2Config.z3 < 254, true
}

