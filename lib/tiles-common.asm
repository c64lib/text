/*
 * c64lib/text/tiles-common.asm
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
#import "common/lib/common.asm"
#import "chipset/lib/vic2.asm"
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
.macro _t2_shiftScreenLeft(cfg, page) {
  // cost ???
  // size ???
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0                              //(2)/2
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
      lda screenAddress + y*40 + 1, x //(4)/3
      sta screenAddress + y*40, x     //(4)/3
    }
    inx                               //(2)/1
    cpx #39                           //(2)/2
  fbne(loop) 
}

.macro _t2_shiftScreenLeftTop(cfg, page) {
  // cost 548cc / 8153cc
  // size 13b   / 160b
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0                                      // 2-2
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow - 1; y++) {
      lda screenAddress + (y + 1)*40 + 1, x   // 4-3
      sta screenAddress + y*40, x             // 4-3
    }
    inx                                       // 2-1
    cpx #39                                   // 2-2
  fbne(loop)                                  // 2-2 / 5-5
}

.macro _t2_shiftScreenTop(cfg, page) {
  // cost 40 * 8 (=320) cycles per line; 7680 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0
  loop:
    .for(var y = cfg.startRow + 1; y <= cfg.endRow; y++) {
      lda screenAddress + y*40, x
      sta screenAddress + (y - 1)*40, x
    }
    inx
    cpx #40
  fbne(loop)
}

.macro _t2_shiftScreenRightTop(cfg, page) {
  // cost 548cc / 8153cc
  // size 13b   / 160b
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #39                                     // 2-2
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow - 1; y++) {
      lda screenAddress + (y + 1)*40 - 1, x   // 4-3
      sta screenAddress + y*40, x             // 4-3
    }
    dex                                       // 2-1
    cpx #0                                    // 2-2
  fbne(loop)                                  // 2-2 / 5-5
}

.macro _t2_shiftScreenRight(cfg, page) {
  // cost 39 * 8 (=312) cycles per line; 7800 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #39
  loop:
    .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
      lda screenAddress + y*40 - 1, x
      sta screenAddress + y*40, x
    }
    dex
    cpx #0
  fbne(loop)
}

.macro _t2_shiftScreenRightBottom(cfg, page) {
  // cost 39 * 8 (=312) cycles per line; 7800 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #39
  loop:
    .for(var y = cfg.endRow - 1; y >= cfg.startRow; y--) {
      lda screenAddress + y*40 - 1, x
      sta screenAddress + (y + 1)*40, x
    }
    dex
    cpx #0
  fbne(loop)
}

.macro _t2_shiftScreenBottom(cfg, page) {
  // cost 40 * 8 (=320) cycles per line; 7680 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0
  loop:
    .for(var y = cfg.endRow - 1; y >= cfg.startRow; y--) {
      lda screenAddress + y*40, x
      sta screenAddress + (y + 1)*40, x
    }
    inx
    cpx #40
  fbne(loop)
}

.macro _t2_shiftScreenLeftBottom(cfg, page) {
  // cost 39 * 8 (=312) cycles per line; 7800 cycles per 25 lines
  .var screenAddress = _t2_screenAddress(cfg, page)
  ldx #0
  loop:
    .for(var y = cfg.endRow - 1; y >= cfg.startRow; y--) {
      lda screenAddress + y*40 + 1, x
      sta screenAddress + (y + 1)*40, x
    }
    inx
    cpx #39
  fbne(loop)
}

// color ram macros
.macro _t2_calculateXOffset(cfg, tileSize) {
  .assert "tilesize 2 is only supported", tileSize, 2
  lda cfg.x
  // todo it works with tilesize 2 only
  and #%00000001
}

.macro _t2_calculateYOffset(cfg, tileSize) {
  .assert "tilesize 2 is only supported", tileSize, 2
  lda cfg.y
  // todo it works with tilesize 2 only
  and #%00000001
}

.macro _t2_shiftColorRamLeft(cfg, tileSize) {
  _t2_shiftInterleavedLeft(cfg, COLOR_RAM, tileSize);
}
.macro _t2_shiftColorRamRight(cfg, tileSize) {
  _t2_shiftInterleavedRight(cfg, COLOR_RAM, tileSize);
}
.macro _t2_shiftColorRamTop(cfg, tileSize) {
  _t2_shiftInterleavedTop(cfg, COLOR_RAM, tileSize);
}
.macro _t2_shiftColorRamBottom(cfg, tileSize) {
  _t2_shiftInterleavedBottom(cfg, COLOR_RAM, tileSize);
}

.macro _t2_shiftInterleavedLeft(cfg, startAddress, tileSize) {
  _t2_calculateXOffset(cfg, tileSize)
  eor #%00000001  // here we need to negate the value
  tay
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    tya
    tax
    loop:
      lda startAddress + y*40 + 1, x
      sta startAddress + y*40, x
      .for (var t = 0; t < tileSize; t++) {
        inx
      }
      cpx #39
    bmi loop
  }
}

.macro _t2_shiftInterleavedRight(cfg, startAddress, tileSize) {
  _t2_calculateXOffset(cfg, tileSize)
  clc
  adc #39
  tay
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    tya
    tax
    loop:
      lda startAddress + y*40 - 2, x
      sta startAddress + y*40 - 1, x
      .for (var t = 0; t < tileSize; t++) {
        dex
      }
      cpx #1
      beq end
      bpl loop
    end:
  }
}

.macro _t2_shiftInterleavedTop(cfg, startAddress, tileSize) {
  ldx #40

  _t2_calculateYOffset(cfg, tileSize)
  
  beq even
  jmp odd
  
  even:
    !loop:
      .for(var y = cfg.startRow + 1; y < cfg.endRow; y = y + 2) {
        lda startAddress + (y + 1)*40 - 1, x
        sta startAddress + y*40 - 1, x
      }
      dex
    fbne(!loop-)
    jmp end
  
  odd: 
    !loop:
      .for(var y = cfg.startRow; y < cfg.endRow; y = y + 2) {
        lda startAddress + (y + 1)*40 - 1, x
        sta startAddress + y*40 - 1, x
      }
      dex
    fbne(!loop-)
  
  end:
}

.macro _t2_shiftInterleavedBottom(cfg, startAddress, tileSize) {

  .eval var isOdd = mod(cfg.endRow - cfg.startRow, 2)
  .print "Is odd = " + isOdd

  ldx #40

  _t2_calculateYOffset(cfg, tileSize)
  
  beq even
  jmp odd
  
  even:
    !loop:
      .for(var y = cfg.endRow - 1 - isOdd; y >= cfg.startRow; y = y - 2) {
        lda startAddress + y*40 - 1, x
        sta startAddress + (y + 1)*40 - 1, x
      }
      dex
    fbne(!loop-)
    jmp end
  
  odd: 
    !loop:
      .for(var y = cfg.endRow - 2 + isOdd; y >= cfg.startRow; y = y - 2) {
        lda startAddress + y*40 - 1, x
        sta startAddress + (y + 1)*40 - 1, x
      }
      dex
    fbne(!loop-)
  
  end:
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
