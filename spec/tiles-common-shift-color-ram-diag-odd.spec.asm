#import "64spec/lib/64spec.asm"
#import "../lib/tiles-color-ram-shift.asm"
#import "common/lib/invoke-global.asm"

sfspec: init_spec()

  describe("_shiftInterleavedTopLeft odd")

    it("shifts mem top left by 1 from [0,0]"); {

      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #0
      sta x
      sta y

      jsr shiftInterleavedTopLeft

      assert_bytes_equal 1000: testScreenData: expectedScreenTopLeft0
    }

    it("shifts mem top left by 1 from [1,1]"); {

      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #1
      sta x
      sta y

      jsr shiftInterleavedTopLeft

      assert_bytes_equal 1000: testScreenData: expectedScreenTopLeft1
    }

  describe("_shiftInterleavedTopRight")

    it("shifts mem top right by 1 from [0,0]"); {

      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #0
      sta x
      sta y

      jsr shiftInterleavedTopRight

      assert_bytes_equal 1000: testScreenData: expectedScreenTopRight0
    }


    it("shifts mem top right by 1 from [1,1]"); {

      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #1
      sta x
      sta y

      jsr shiftInterleavedTopRight

      assert_bytes_equal 1000: testScreenData: expectedScreenTopRight1
    }


  describe("_shiftInterleavedBottomLeft")

    it("shifts mem bottom left by 1 from [0,0]"); {

      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #0
      sta x
      sta y

      jsr shiftInterleavedBottomLeft

      assert_bytes_equal 1000: testScreenData: expectedScreenBottomLeft0
    }

    it("shifts mem bottom left by 1 from [1,1]"); {

      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #1
      sta x
      sta y

      jsr shiftInterleavedBottomLeft

      assert_bytes_equal 1000: testScreenData: expectedScreenBottomLeft1
    }


  describe("_shiftInterleavedBottomRight")

    it("shifts mem bottm right by 1 from [0,0]"); {

      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #0
      sta x
      sta y

      jsr shiftInterleavedBottomRight

      assert_bytes_equal 1000: testScreenData: expectedScreenBottomRight0
    }

    it("shifts mem bottm right by 1 from [1,1]"); {

      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward

      lda #1
      sta x
      sta y

      jsr shiftInterleavedBottomRight

      assert_bytes_equal 1000: testScreenData: expectedScreenBottomRight1
    }

finish_spec()

* = * "Data"
x: .word 0
y: .word 0
.namespace c64lib {
  .var @cfg = TileCommonConfig()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 5120/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 23
  .eval @cfg.x = x
  .eval @cfg.y = y
}

initialScreenData0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "1234567890123456789012345678901234567890"
}

initialScreenData1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "1234567890123456789012345678901234567890"
}

testScreenData: {
  .fill 1000, 0
}

expectedScreenTopLeft0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "1234567890123456789012345678901234567890"
}

expectedScreenTopLeft1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "1234567890123456789012345678901234567890"
}

expectedScreenTopRight0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "1234567890123456789012345678901234567890"
}

expectedScreenTopRight1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "1234567890123456789012345678901234567890"
}

expectedScreenBottomLeft0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx"
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..."
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "1234567890123456789012345678901234567890"
}

expectedScreenBottomLeft1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.x"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..x."
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "1234567890123456789012345678901234567890"
}

expectedScreenBottomRight0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx."
  .text "1234567890123456789012345678901234567890"
}

expectedScreenBottomRight1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x"
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "x.xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text ".x..xx..xx..xx..xx..xx..xx..xx..xx..xx.."
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx"
  .text "1234567890123456789012345678901234567890"
}

codeBegin:
shiftInterleavedTopLeft:      .namespace c64lib { _t2_shiftInterleavedTopLeft(@cfg, testScreenData, 2); rts }
shiftInterleavedTopRight:     .namespace c64lib { _t2_shiftInterleavedTopRight(@cfg, testScreenData, 2); rts }
shiftInterleavedBottomLeft:   .namespace c64lib { _t2_shiftInterleavedBottomLeft(@cfg, testScreenData, 2); rts }
shiftInterleavedBottomRight:  .namespace c64lib { _t2_shiftInterleavedBottomRight(@cfg, testScreenData, 2); rts }
codeEnd:

copyLargeMemForward:
                        #import "common/lib/sub/copy-large-mem-forward.asm"

.print "Total size of tested subroutines = " + (codeEnd - codeBegin) + " bytes"