/*
 * MIT License
 *
 * Copyright (c) 2017-2023 c64lib
 * Copyright (c) 2017-2023 Maciej Małecki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#import "common/lib/invoke.asm"
#import "common/lib/mem.asm"
#import "common/lib/math.asm"
#import "chipset/lib/vic2.asm"
#importonce
.filenamespace c64lib

.macro incText(text, count) {
  // thank you Alex Goldblat!
  .fill text.size(), text.charAt(i) + count
}
.assert "incText", { incText("ab", 1)} , { .text "bc" }

// Hosted subroutines
.macro outHexNibbleOfs(charsetOffset) {
  invokeStackBegin(returnPtr)

  pullParamW(storeHex)   // IN: screen location ptr
  pullParamW(loadByte)   // IN: byte ptr

  lda loadByte:$ffff // load byte to process
  and #%00001111   // clear first digit
  tay
  lda hexChars, y
  sta storeHex:$ffff

  invokeStackEnd(returnPtr)
  rts

  // local variables
  returnPtr:  .word 0
  hexChars:   incText("0123456789abcdef", charsetOffset)
}

/*
 * Copies a block (rectangle) from given location denoted in A/X registers into target location.
 * This macro hosts a subroutine and can be called several times to cover several different locations and block sizes.
 *
 * Macro parameters:
 * - width: virtual width of the block, ranges 1-40
 * - height: virtual height of the block, rangles 1-25
 * - screenTarget: a 1000 bytes screen memory. Note, if block is smaller than 25 rows and should not start from the top and left, you should add corresponding number of bytes to this address: x+40*y
 * - colorSource: a coloring table, denoting color per character
 * - colorTarget: a color RAM target, it is configurable because you need to add here the same adjustments as for screenTarget: x+40*y
 *
 * Subroutine parameters:
 * - - IN: A - source address lsb, X - source address hsb
 * DESTROYS: A,X,Y
 */
.macro copyScreenBlock(width, height, screenTarget, colorSource, colorTarget) {
    sta sourceAddress
    stx sourceAddress + 1
    set16(screenTarget, destAddress)
    set16(colorTarget, colorDestAddress)
    ldy #height
nextLine:
    ldx #width
    nextChar:
        dex
        tya
        pha
        lda sourceAddress:$FFFF,x
        tay
        sta destAddress:$FFFF,x
        lda colorSource,y
        sta colorDestAddress:$FFFF,x
        pla
        tay
        cpx #0
    bne nextChar
    add16(width, sourceAddress)
    add16(40, destAddress)
    add16(40, colorDestAddress)
    dey
    bne nextLine
    rts
}

/*
 * Display text pointed by text pointer at screen (memory) location pointed by screen location pointer.
 * Text must be ended with $FF and shall not be longer than 256 characters.
 *
 * Stack parameters (order of pushing)
 * - text pointer LO
 * - text pointer HI
 *
 * Register parameters
 * - A color code
 * - X x pos
 * - Y y pos
 *
 * Macro parameters:
 * - screenAddress
 * - colorRamAddress
 */
.macro outTextXYC(screenAddress, colorRamAddress) {
    // preserve X,Y,C
    stx xPos
    sty yPos
    sta col
    lda #0
    sta xPos + 1
    lda #<screenAddress
    sta storeText
    lda #>screenAddress
    sta storeText + 1
    lda #<colorRamAddress
    sta storeColor
    lda #>colorRamAddress
    sta storeColor + 1
    // get params from stack
    invokeStackBegin(returnPtr)
    pullParamW(loadText)
    // translate X,Y to memory locations
    ldy yPos
    mulByRows:
      add16(40, storeText)
      add16(40, storeColor)
      dey
    bne mulByRows
    add16 xPos:storeText
    add16 xPos:storeColor
    // out text and color
    ldx #$00
    loop:
        lda loadText:$ffff, x
        cmp #$ff
        beq end
        sta storeText:screenAddress, x
        lda col
        sta storeColor:colorRamAddress, x
        inx
    bne loop
    end:
    // restore stack
    invokeStackEnd(returnPtr)
    rts
    // local variables
    returnPtr: .word 0
    xPos: .word 0
    yPos: .byte 0
    col: .byte 0
}

/*
 * Display text pointed by text pointer at screen (memory) location pointed by screen location pointer.
 * Text must be ended with $FF and shall not be longer than 256 characters.
 * Number will be displayed as hexagonal if unpacked, or decimal when BCD packed.
 *
 * Stack parameters (order of pushing)
 * - byte pointer LO
 * - byte pointer HI
 *
 * Register parameters
 * - A color code
 * - X x pos
 * - Y y pos
 *
 * Macro parameters:
 * - screenAddress
 * - colorRamAddress
 */
.macro outNumberXYC(screenAddress, colorRamAddress) {
    // preserve X,Y,C
    stx xPos
    sty yPos
    sta col
    // get params from stack
    invokeStackBegin(returnPtr)
    pullParamW(loadByte)   // IN: byte ptr
    // translate X,Y to memory locations
    ldy yPos
    mulByRows:
      add16(40, storeHex)
      add16(40, storeColor)
      dey
    bne mulByRows
    add16 xPos:storeHex
    add16 xPos:storeColor

    lda loadByte:$ffff // load byte to process

    ldx #$00
    sta ldx1 + 1 // preserve for second digit
    lsr          // shift right 4 bits
    lsr
    lsr
    lsr
    sta ldx0 + 1 // preserve for first digit
    lda ldx1 + 1 // load second digit
    and #%1111   // clear first digit
    sta ldx1 + 1 // store it again
    jsr ldx0     // display first digit
    jsr ldx1     // display second digit
    jmp end
    ldx0:
      ldy #$00
    jmp out
    ldx1:
      ldy #$00
    jmp out
    out:
      lda hexChars, y
      sta storeHex:screenAddress, x
      lda col
      sta storeColor:colorRamAddress, x
      inx
      rts
    end:

    invokeStackEnd(returnPtr)
    rts
    // local variables
    returnPtr:  .word 0
    hexChars:   .text "0123456789abcdef"
    xPos: .word 0
    yPos: .byte 0
    col: .byte 0
}
