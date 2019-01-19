#import "64spec/lib/64spec.asm"
#import "../lib/tiles2.asm"

sfspec: init_spec()
  describe("_t2_shiftScreenLeft")
  
  it("shifts screen to the left by 1 byte"); {
    jsr shiftScreenLeft
    
    assert_bytes_equal 1000: testScreenData: expectedScreenData_left
  }
  
  describe("_t2_shiftScreenRight")
  
  it("shifts screen to the right by 1 byte"); {
    jsr shiftScreenRight
    
    assert_bytes_equal 1000: testScreenData: expectedScreenData_right
  }

finish_spec()

* = * "Data"
.namespace c64lib {
.var @cfg = Tile2Config()
.eval @cfg.bank = 0
.eval @cfg.page0 = 5120/1024
.eval @cfg.startRow = 1
.eval @cfg.endRow = 23
}

shiftScreenLeft: .namespace c64lib { _t2_shiftScreenLeft(@cfg, 0); rts }
shiftScreenRight: .namespace c64lib { _t2_shiftScreenRight(@cfg, 0); rts }

.align $400
testScreenData: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    .fill 40, <(v + i)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
.print "test data address = " + testScreenData

expectedScreenData_left: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    .fill 39, <(v + i + 1)
    .byte <(v + 39)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
expectedScreenData_right: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow; y++) {
    .byte <(v + 1)
    .fill 39, <(v + i + 1)
    .eval v++
  }
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
