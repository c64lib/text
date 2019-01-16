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

/*
 * Config record for 2x2 tile scrollable playfield.
 */
.struct Tile2Config {
  // start text row of the tiled playfield, values 0..23
  startRow,
  // end text row of the tiled playfield, values 1..24
  endRow,
  // address (16 bit) of page 0 (1024 bytes) for double buffering
  page0,
  // address (16 bit) of page 1 (1024 bytes) for double buffering
  page1,
  // address (16 bit) of playfield width in tiles (1 byte)
  width,
  // address (16 bit) of playfield height (1 byte)
  height,
  // address (16 bit) for tile definitions (1kb)
  tileDefinition,
  // address (16 bit) for tile colors (256b)
  tileColors,
  // address (16 bit) for map definition (width * height) bytes
  mapDefinition,
  // address (16 bit) for X position of top left corner (1b)
  x,
  // address (16 bit) for Y position of top left corner (1b)
  y,
  // address (16 bit) for display phase counter
  phase
}

.macro drawTile2(tile2Config) {
  .assert "startRow must be smaller than endRow", tile2Config.startRow < tile2Config.endRow, true
}

.var cfg = Tile2Config()
.eval cfg.startRow = 0
.eval cfg.endRow = 24
drawTile2(cfg)