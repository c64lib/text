#import "64spec/lib/64spec.asm"
#import "../lib/tiles-common.asm"
#import "common/lib/invoke-global.asm"

sfspec: init_spec()

  describe("_shiftInterleavedLeft")
  
    it("shifts given memory to the left by 1 byte from position [0, 0]"); {
    
      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #0
      sta x
      sta y
  
      jsr shiftInterleavedLeft
      
      assert_bytes_equal 1000: testScreenData: expectedScreenLeft0
    }

    it("shifts given memory to the left by 1 byte from position [1, 1]"); {
    
      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #1
      sta x
      sta y
  
      jsr shiftInterleavedLeft
      
      assert_bytes_equal 1000: testScreenData: expectedScreenLeft1
    }

  describe("_shiftInterleavedRight")
  
    it("shifts given memory to the right by 1 byte from position [0, 0]"); {
    
      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #0
      sta x
      sta y
  
      jsr shiftInterleavedRight
      
      assert_bytes_equal 1000: testScreenData: expectedScreenRight0
    }

    it("shifts given memory to the right by 1 byte from position [1, 1]"); {
    
      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #1
      sta x
      sta y
  
      jsr shiftInterleavedRight
      
      assert_bytes_equal 1000: testScreenData: expectedScreenRight1
    }

  describe("_shiftInterleavedTop")
  
    it("shifts given memory to the top by 1 byte from position [0, 0]"); {
    
      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #0
      sta x
      sta y
  
      jsr shiftInterleavedTop
      
      assert_bytes_equal 1000: testScreenData: expectedScreenTop0
    }

    it("shifts given memory to the top by 1 byte from position [1, 1]"); {
    
      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #1
      sta x
      sta y
  
      jsr shiftInterleavedTop
      
      assert_bytes_equal 1000: testScreenData: expectedScreenTop1
    }
    
  describe("_shiftInterleavedBottom")
  
    it("shifts given memory to the bottom by 1 byte from position [0, 0]"); {
    
      c64lib_pushParamW(initialScreenData0)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #0
      sta x
      sta y
  
      jsr shiftInterleavedBottom
      
      assert_bytes_equal 1000: testScreenData: expectedScreenBottom0
    }

    it("shifts given memory to the bottom by 1 byte from position [1, 1]"); {
    
      c64lib_pushParamW(initialScreenData1)
      c64lib_pushParamW(testScreenData)
      c64lib_pushParamW(1000)
      jsr copyLargeMemForward
      
      lda #1
      sta x
      sta y
  
      jsr shiftInterleavedBottom
      
      assert_bytes_equal 1000: testScreenData: expectedScreenBottom1
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

expectedScreenLeft0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..." 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xxx" 
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenLeft1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
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
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx" 
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.." 
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.." 
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenRight0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "xxx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "...xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenRight1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
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
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx" 
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenTop0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
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
  .text "..xx..xx..xx..xx..xx..xx..xx..xx..xx..xx" 
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenTop1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
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
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenBottom0: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
  .text "xx..xx..xx..xx..xx..xx..xx..xx..xx..xx.." 
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
  .text "1234567890123456789012345678901234567890" 
}

expectedScreenBottom1: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890" 
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
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text "x..xx..xx..xx..xx..xx..xx..xx..xx..xx..x" 
  .text ".xx..xx..xx..xx..xx..xx..xx..xx..xx..xx." 
  .text "1234567890123456789012345678901234567890" 
}


shiftInterleavedLeft:   .namespace c64lib { _shiftInterleavedLeft(@cfg, testScreenData, 2); rts }
shiftInterleavedRight:  .namespace c64lib { _shiftInterleavedRight(@cfg, testScreenData, 2); rts }
shiftInterleavedTop:    .namespace c64lib { _shiftInterleavedTop(@cfg, testScreenData, 2); rts }
shiftInterleavedBottom: .namespace c64lib { _shiftInterleavedBottom(@cfg, testScreenData, 2); rts }
copyLargeMemForward:   
                        #import "common/lib/sub/copy-large-mem-forward.asm"
