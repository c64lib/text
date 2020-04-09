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
  and #%10000000
}

.macro _t2_calculateYOffset(cfg, tileSize) {
  .assert "tilesize 2 is only supported", tileSize, 2
  lda cfg.y
  // todo it works with tilesize 2 only
  and #%10000000
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

.macro _t2_shiftColorRamTopLeft(cfg, tileSize) {
  _t2_shiftInterleavedTopLeft(cfg, COLOR_RAM, tileSize);
}
.macro _t2_shiftColorRamTopRight(cfg, tileSize) {
  _t2_shiftInterleavedTopLeft(cfg, COLOR_RAM, tileSize);
}
.macro _t2_shiftColorRamBottomLeft(cfg, tileSize) {
  _t2_shiftInterleavedBottomLeft(cfg, COLOR_RAM, tileSize);
}
.macro _t2_shiftColorRamBottomRight(cfg, tileSize) {
  _t2_shiftInterleavedBottomRight(cfg, COLOR_RAM, tileSize);
}


// orthogonal shifts
.macro _t2_shiftInterleavedLeft(cfg, startAddress, tileSize) {
  _t2_calculateXOffset(cfg, tileSize)
  eor #$ff  // here we need to negate the value
  lsr
  lsr
  lsr
  lsr
  lsr
  lsr
  lsr
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
  lsr
  lsr
  lsr
  lsr
  lsr
  lsr
  lsr
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

// diagonal shifts

.macro _t2_shiftInterleavedTopLeft(cfg, startAddress, tileSize) {
  .for(var y = cfg.startRow; y < cfg.endRow; y++) {
    ldx #0
    loop:
      lda startAddress + (y + 1)*40 + 1, x
      sta startAddress + y*40, x
      inx
      cpx #39
      bne loop
  }

/*
  ldx #0

  _t2_calculateYOffset(cfg, tileSize)
  
  beq even
  jmp odd
  
  even:
    !loop:
      .for(var y = cfg.startRow; y < cfg.endRow; y = y + 2) {
        // here we to copy every second byte
        lda startAddress + (y + 1)*40 + 2, x
        sta startAddress + y*40 + 1, x
        .if (y < cfg.endRow - 1) {
          // but here we have to copy whole line
          lda startAddress + (y + 2)*40 + 1, x
          sta startAddress + (y + 1)*40, x
          lda startAddress + (y + 2)*40 + 2, x
          sta startAddress + (y + 1)*40 + 1, x
        }
      }
      inx
      inx
      cpx #39
    fbmi(!loop-)
    jmp end
  
  odd: 
    !loop:
      .for(var y = cfg.startRow; y < cfg.endRow; y = y + 2) {
        // but here we have to copy whole line
        lda startAddress + (y + 1)*40 + 1, x
        sta startAddress + (y + 0)*40, x
        lda startAddress + (y + 1)*40 + 2, x
        sta startAddress + (y + 0)*40 + 1, x
        .if (y < cfg.endRow - 1) {
          // here we to copy every second byte
          lda startAddress + (y + 2)*40 + 1, x
          sta startAddress + (y + 1)*40 + 0, x
        }
      }
      inx
      inx
      cpx #39
    fbmi(!loop-)

  end:
  */
}

.macro _t2_shiftInterleavedTopRight(cfg, startAddress, tileSize) {
  .for(var y = cfg.startRow; y < cfg.endRow; y++) {
    ldx #39
    loop:
      lda startAddress + (y + 1)*40 - 1, x
      sta startAddress + y*40, x
      dex
      bne loop
  }
}

/*
.macro _t2_shiftInterleavedTopRight(cfg, startAddress, tileSize) {
  ldx #39

  _t2_calculateYOffset(cfg, tileSize)
  
  beq even
  jmp odd
  
  even:
    !loop:
      .for(var y = cfg.startRow; y < cfg.endRow; y = y + 2) {
        // here we to copy every second byte
        lda startAddress + (y + 1)*40 - 2, x
        sta startAddress + y*40 - 1, x
        .if (y < cfg.endRow - 1) {
          // but here we have to copy whole line
          lda startAddress + (y + 2)*40 - 1, x
          sta startAddress + (y + 1)*40, x
          lda startAddress + (y + 2)*40 - 2, x
          sta startAddress + (y + 1)*40 - 1, x
        }
      }
      dex
      dex
      cpx #1
    fbne(!loop-)
    .for(var y = cfg.startRow; y < cfg.endRow; y = y + 2) {
      lda startAddress + (y + 2)*40
      sta startAddress + (y + 1)*40 + 1
    }
    jmp end
  
  odd: 
    !loop:
      .for(var y = cfg.startRow; y < cfg.endRow; y = y + 2) {
        // but here we have to copy whole line
        lda startAddress + (y + 1)*40 - 1, x
        sta startAddress + (y + 0)*40, x
        lda startAddress + (y + 1)*40 - 2, x
        sta startAddress + (y + 0)*40 - 1, x
        .if (y < cfg.endRow - 1) {
          // here we to copy every second byte
          lda startAddress + (y + 2)*40 + 1, x
          sta startAddress + (y + 1)*40 + 0, x
        }
      }
      dex
      dex
      cpx #1
    fbmi(!loop-)

  end:
}
*/

.macro _t2_shiftInterleavedBottomLeft(cfg, startAddress, tileSize) {
  .for(var y = cfg.endRow; y > cfg.startRow; y--) {
    ldx #0
    loop:
      lda startAddress + (y - 1)*40 + 1, x
      sta startAddress + y*40, x
      inx
      cpx #39
      bne loop
  }
}

.macro _t2_shiftInterleavedBottomRight(cfg, startAddress, tileSize) {
  .for(var y = cfg.endRow; y > cfg.startRow; y--) {
    ldx #39
    loop:
      lda startAddress + (y - 1)*40 - 1, x
      sta startAddress + y*40, x
      dex
      bne loop
  }
}
