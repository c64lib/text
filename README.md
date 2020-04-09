# c64lib/text
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CircleCI](https://circleci.com/gh/c64lib/text/tree/master.svg?style=svg)](https://circleci.com/gh/c64lib/text/tree/master)
[![CircleCI](https://circleci.com/gh/c64lib/text/tree/develop.svg?style=svg)](https://circleci.com/gh/c64lib/text/tree/develop)
[![Gitter](https://badges.gitter.im/c64lib/community.svg)](https://gitter.im/c64lib/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Documentation
For complete documentation please refer: 
https://c64lib.github.io/docu/libs/text

## Change log
### Changes in 0.2.0

* Public symbols are now declared globally in "-global.asm" files

* New library file: `tiles-common.asm` - common stuff for backdrop scrolling.
* New struct: `tiles-common.asm/TileCommonConfig` - configuration structure for any size scrolling system.

* New library file: `tiles-2x2.asm` - scrolling routines for 2x2 tile backdrops.
* New struct: `tiles-2x2.asm/Tile2Config` - configuration structure for 2x2 scrolling system.
* New macro: `tiles-2x2.asm/tile2Init` - initialize 2x2 scrolling system.

* New library file: `tiles-color-ram-shift.asm` - dedicated macros for scrolling color RAM.

* New library file: `tiles-screen-shift.asm` - dedicated macros for scrolling video RAM.
