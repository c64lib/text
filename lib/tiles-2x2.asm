#import "tiles-common.asm" 
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

.function toTileCommonConfig(tile2Config) {
  .var tileCommonCfg = TileCommonConfig()
  .eval tileCommonCfg.startRow = tile2Config.startRow
  .eval tileCommonCfg.endRow = tile2Config.endRow
  .eval tileCommonCfg.bank = tile2Config.bank
  .eval tileCommonCfg.page0 = tile2Config.page0
  .eval tileCommonCfg.page1 = tile2Config.page1
  .return tileCommonCfg
}
