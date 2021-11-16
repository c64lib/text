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
 * Returns tile number denoted by current viewport position and given relative coordinates.
 *
 * In:  X - relative X coordinates rounded to the whole character
 *      Y - relative Y coordinates rounded to the whole character
 * Out: A - tile number (tile code)
 * Mod: A,X,Y
 */
.macro decodeTile(cfg) {
  tya
  clc
  adc cfg.y + 1
  tay
  txa
  clc
  adc cfg.x + 1
  tax
  lda cfg.mapOffsetsLo,y
  sta mapPtr
  lda cfg.mapOffsetsHi,y
  sta mapPtr + 1
  lda mapPtr:$FFFF,x
}

/*
 * Draws a tile on the screen, but only makes sense when [x,y] = [0,0].
 *
 * In:  X - relative X offset of the tile
 * In:  Y - relative Y offset of the tile
 * Mod: A
 */
.macro drawTile(cfg, screen, colorRam) {
  // save regs
  txa
  pha
  tya
  pha
  // calculate screen position
  tya
  asl
  tay
  lda rowOffsetsLo + cfg.startRow,y
  sta lt
  lda colorOffsetsLo + cfg.startRow,y
  sta clt
  lda rowOffsetsHi + cfg.startRow,y
  sta lt + 1
  lda colorOffsetsHi + cfg.startRow,y
  sta clt + 1
  lda rowOffsetsLo + cfg.startRow,y
  sta rt
  lda colorOffsetsLo + cfg.startRow,y
  sta crt
  lda rowOffsetsHi + cfg.startRow,y
  sta rt + 1
  lda colorOffsetsHi + cfg.startRow,y
  sta crt + 1
  iny
  lda rowOffsetsLo + cfg.startRow,y
  sta lb
  lda colorOffsetsLo + cfg.startRow,y
  sta clb
  lda rowOffsetsHi + cfg.startRow,y
  sta lb + 1
  lda colorOffsetsHi + cfg.startRow,y
  sta clb + 1
  lda rowOffsetsLo + cfg.startRow,y
  sta rb
  lda colorOffsetsLo + cfg.startRow,y
  sta crb
  lda rowOffsetsHi + cfg.startRow,y
  sta rb + 1
  lda colorOffsetsHi + cfg.startRow,y
  sta crb + 1
  dey
  tya
  lsr
  tay
  // calculate tile number
  lda cfg.mapOffsetsLo,y
  sta mapPtr
  lda cfg.mapOffsetsHi,y
  sta mapPtr + 1
  ldy mapPtr:$ffff,x // Y <- tile number

  txa
  asl
  tax

  // fill screen data
  lda cfg.tileDefinition,y
  sta lt: $ffff,x
  lda cfg.tileDefinition + 512,y
  sta lb: $ffff,x
  inx
  lda cfg.tileDefinition + 256,y
  sta rt: $ffff,x
  lda cfg.tileDefinition + 768,y
  sta rb: $ffff,x
  dex

  // fill color RAM
  lda cfg.tileColors,y
  sta clt: $ffff,x
  sta clb: $ffff,x
  inx
  sta crt: $ffff,x
  sta crb: $ffff,x
  dex

  // restore regs
  pla
  tay
  pla
  tax
  rts
  // --- data ---
  rowOffsetsLo: .fill 25, <(screen + i*40)
  rowOffsetsHi: .fill 25, >(screen + i*40)
  colorOffsetsLo: .fill 25, <(colorRam + i*40)
  colorOffsetsHi: .fill 25, >(colorRam + i*40)
}

/**
 * Shifts screen data to the left by one character.
 *
 * Parameters:
 * - cfg - tileset configuration.
 * - page - which page to use as src (0 or 1).
 *
 * Mod: A, X
 */
.macro shiftScreenLeft(cfg, page) {
  .if (page == 0) {
    _t2_shiftScreenLeft(cfg, 0, 1)
  } else {
    _t2_shiftScreenLeft(cfg, 1, 0)
  }
}

/**
 * Shifts color RAM to the left by one character.
 *
 * Parameters:
 * - cfg - tileset configuration.
 *
 * Mod: A, X, Y
 */
.macro shiftColorRamLeft(cfg) { _t2_shiftColorRamLeft(cfg, 2) }

/*
 * Decode rightmost column of the playfield into given screen page.
 *
 * Mod: A, X, Y
 */
.macro decodeScreenRight(cfg, page) { _t2_decodeScreenRight(cfg, page) }

// ----- Private stuff. -----

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
  adc #20
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

