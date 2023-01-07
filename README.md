# c64lib/text
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CircleCI](https://circleci.com/gh/c64lib/text/tree/master.svg?style=shield)](https://circleci.com/gh/c64lib/text/tree/master)
[![CircleCI](https://circleci.com/gh/c64lib/text/tree/develop.svg?style=shield)](https://circleci.com/gh/c64lib/text/tree/develop)
[![Gitter](https://badges.gitter.im/c64lib/community.svg)](https://gitter.im/c64lib/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Documentation
For complete documentation please refer:
https://c64lib.github.io/docu/libs/text

## Change log

### Changes in 0.4.0

* New macro: `text.asm\copyScreenBlock`.
* New macro: `text.asm\outTextXYC`.

### Changes in 0.3.0

* New macro: `outHexNibbleOfs`
* New subroutine: `outHexNibble`
* Screen shift to the left (both screen mem and color RAM) are well tested with T-Rex 64 release.
* New macro: `tiles-2x2.asm/decodeTile`.
* New macro: `tiles-2x2.asm/drawTile`.
* New macro: `tiles-2x2.asm/shiftScreenLeft`.
* New macro: `tiles-2x2.asm/shiftColorRamLeft`.
* New macro: `tiles-2x2.asm/decodeScreenRight`.
* New macro: `tiles-2x2.asm/decodeColorRight`.

### Changes in 0.2.0

* Public symbols are now declared globally in "-global.asm" files
* New library file: `tiles-common.asm`.
* New struct: `tiles-common.asm/TileCommonConfig`.
* New library file: `tiles-2x2.asm`.
* New struct: `tiles-2x2.asm/Tile2Config`.
* New macro: `tiles-2x2.asm/tile2Init`.
* New library file: `tiles-color-ram-shift.asm`.
* New library file: `tiles-screen-shift.asm`.
