/*
 * c64lib/text/tiles-color-ram-shift.asm
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
#import "common/lib/common.asm"
#import "chipset/lib/vic2.asm"
#import "tiles-common.asm"
#importonce
.filenamespace c64lib

// = color ram macros =
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

// = color ram shifting routines =
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

// = color ram internals =
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
