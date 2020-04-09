/*
 * c64lib/text/tiles-common.asm
 *
 * A library that supports drawing and 4-directional scrolling of 2x2 tile map using text modes
 * of VIC-II. All three text modes are supported.
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
 * Config record for common tiled background scrollable playfield.
 */
.struct TileCommonConfig {
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
  y

}

// = other stuff =

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
