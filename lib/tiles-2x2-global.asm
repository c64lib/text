#import "tiles-2x2.asm"
#importonce
.filenamespace c64lib

.macro @c64lib_tile2Init(cfg) { tile2Init(cfg) }
.macro @c64lib_decodeTile(cfg) { decodeTile(cfg) }
.macro @c64lib_drawTile(cfg, screen, colorRam) { drawTile(cfg, screen, colorRam) }
