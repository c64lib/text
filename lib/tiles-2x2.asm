#import "tiles-common.asm" 
#import "tiles-screen-shift.asm"
#import "tiles-color-ram-shift.asm"
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
  // address (8 or 16 bit) for X position of top left corner (2b), 1st byte - sub tile position, 2nd byte - tile position
  x,
  // address (8 or 16 bit) for Y position of top left corner (2b), 1st byte - sub tile position, 2nd byte - tile position
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
  _t2_initMapOffsets(cfg)
}

/* 
 * initialize mapOffsetsLo and mapOffsetsHi buffers
 *
 * Mod: A, X, Y
 */
.macro _t2_initMapOffsets(cfg) {
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
  jmp end
    // local variables
    width: .word 0
    temp: .word 0
  end:
}

/*
 * In:  X - x-offset of the viewport
 * Out: A - tile number (code)
 * Mod: A, Y
 */
.macro _t2_decodeTile(cfg, lineNo) {
    ldy cfg.y + 1                   // "y" contains a y-offset of the viewport
    lda cfg.mapOffsetsLo + lineNo,y // 
    sta mapPtr
    lda cfg.mapOffsetsHi + lineNo,y
    sta mapPtr + 1
    lda mapPtr:$FFFF,x
}

/*
 * Decode rightmost column of the playfield into given screen page.
 *
 * Mod: A, X, Y
 */
.macro _t2_decodeScreenRight(cfg, page) {

  .var pageAddress = _t2_screenAddress(cfg, page)


  cld
  clc
  lda cfg.x
  and #%10000000
  bne nextTile
    lda cfg.x + 1                       // load (tile) X position
    adc #19                             // we will draw last column
    jmp endNextTile
  nextTile:
    lda cfg.x + 1
    adc #20
  endNextTile:
  tax                                 // X contains a x coodinate of the map tile

  lda cfg.y                           // load subtile Y position
  and #%10000000
  beq yEven
                                      // Y position is odd
    _t2_decodeTile(cfg, 0)
    tay                               // X contains tile number
   
    lda cfg.x
    and #%10000000
    bne xOdd
      lda cfg.tileDefinition + 512,y
      sta pageAddress + 39
      jmp done
    xOdd:
      lda cfg.tileDefinition + 768,y
      sta pageAddress + 39
    done: 
  yEven:
  .for (var y = cfg.startRow; y <= cfg.endRow; y = y+2) {
    _t2_decodeTile(cfg, (y - cfg.startRow)/2)
    tay
    
    lda cfg.x
    and #%10000000
    beq xEven
      lda cfg.tileDefinition,y
      sta pageAddress + (y*40) + 39
      .if (y + 1 <= cfg.endRow) {
        lda cfg.tileDefinition + 512,y
        sta pageAddress + ((y + 1)*40) + 39
      }
      jmp done
    xEven:
      lda cfg.tileDefinition + 256,y
      sta pageAddress + (y*40) + 39
      .if(y + 1 <= cfg.endRow) {
        lda cfg.tileDefinition + 768,y
        sta pageAddress + ((y + 1)*40) + 39
      }
    done: 
  }
}

/*
 * Decode rightmost column of the color data.
 *
 * Mod: A, X, Y
 */
.macro _t2_decodeColorRight(cfg, colorPage) {

  cld
  lda cfg.x + 1   
  clc
  adc #19
  tax

  lda cfg.y
  and #%10000000
  beq yEven
    _t2_decodeTile(cfg, 0)
    tay

    lda cfg.tileColors,y
    sta colorPage + 39
  yEven:
  .for (var y = cfg.startRow; y <= cfg.endRow; y = y+2) {
    _t2_decodeTile(cfg, (y - cfg.startRow)/2)
    tay

    lda cfg.tileColors,y
    sta colorPage + (y*40) + 39
    .if (y + 1 <= cfg.endRow) {
      sta colorPage + ((y + 1)*40) + 39
    }
  }
}

.macro _t2_validate(tile2Config) {
  .assert "startRow must be smaller than endRow", tile2Config.startRow < tile2Config.endRow, true
  /*
  .assert "z0 must be defined on zero page", tile2Config.z0 < 254, true
  .assert "z1 must be defined on zero page", tile2Config.z1 < 254, true
  .assert "z2 must be defined on zero page", tile2Config.z2 < 254, true
  .assert "z3 must be defined on zero page", tile2Config.z3 < 254, true
  */
}

