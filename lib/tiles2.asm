/*
 * c64lib/text/tiles2.asm
 *
 * A library that supports drawing and 4-directional scrolling of 2x2 tile map using text modes
 * of VIC-2. All three text modes are supported.
 *
 * Color limitations:
 *  - color RAM is configured per 2x2 tile
 *
 * Author:    Maciej Malecki
 * License:   MIT
 * (c):       2019
 * GIT repo:  https://github.com/c64lib/text
 */
#importonce
.filenamespace c64lib

// ==== Public declarations ====

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
  // address (8 or 16 bit) of playfield width in tiles (1 byte)
  width,
  // address (8 or 16 bit) of playfield height (1 byte)
  height,
  // address (8 or 16 bit) for tile definitions (1kb)
  tileDefinition,
  // address (8 or 16 bit) for tile colors (256b)
  tileColors,
  // address (8 or 16 bit) for map definition (width * height) bytes
  mapDefinition,
  // address (8 or 16 bit) for X position of top left corner (2b), 1st byte - tile position, 2nd byte - sub tile position
  x,
  // address (8 or 16 bit) for Y position of top left corner (2b), 1st byte - tile position, 2nd byte - sub tile position
  y,
  // address (8 or 16 bit) for display phase counter
  phase,
  // ---- zero page mandatory variables
  // general purpose zero page accumulator for indirect addressing
  addrAccumulator
}

// ==== Public hosted subroutines ====

.macro tile2Init(cfg) {
  _t2_validate(cfg)
  lda #$00
  sta cfg.phase
}

.macro tile2Draw(cfg) {
  _t2_validate(cfg)
}

.macro tile2Animate(cfg) {
  _t2_validate(cfg)
}

// ==== Private stuff ====

.macro _t2_shiftScreenLeft(cfg) {
}

.macro _t2_validate(tile2Config) {
  .assert "startRow must be smaller than endRow", tile2Config.startRow < tile2Config.endRow, true
  .assert "addrAccumulator must be defined on zero page", tile2Config.addrAccumulator < 256, true
}

.function _t2_screenAddress(cfg, page) {
  .return (cfg.bank*16 + _t2_pageToPageNumber(cfg, page)) * 1024
}

.function _t2_pageToPageNumber(cfg, page) {
  .if (page == 0) {
    .return cfg.page0;
  } else {
    .return cfg.page1
  }
}

// to be removed
.var cfg = Tile2Config()
.eval cfg.startRow = 0
.eval cfg.endRow = 24
.eval cfg.phase = $2
.eval cfg.addrAccumulator = $3
tile2Init(cfg)
tile2Draw(cfg)
tile2Animate(cfg)
