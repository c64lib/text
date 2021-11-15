#import "64spec/lib/64spec.asm"
#import "../lib/tiles-screen-shift.asm"

sfspec: init_spec()
  describe("_t2_shiftScreenRightTop")

  it("shifts screen to the right/top by 1 byte"); {
    jsr shiftScreenRightTop

    assert_bytes_equal 1000: testScreenData: expectedScreenData_rightTop
  }

finish_spec()

* = * "Data"
.namespace c64lib {
  .var @cfg = TileCommonConfig()
  .eval @cfg.bank = 0
  .eval @cfg.page0 = 4096/1024
  .eval @cfg.startRow = 1
  .eval @cfg.endRow = 23
}

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

expectedScreenData_rightTop: {
  .for(var y = 0; y < cfg.startRow; y++) {
    .fill 40, i
  }
  .var v = 0
  .for(var y = cfg.startRow; y <= cfg.endRow - 1; y++) {
    .byte <v
    .fill 39, <(v + i + 1)
    .eval v++
  }
  .fill 40, <(v + i)
  .for(var y = cfg.endRow + 1; y < 25; y++) {
    .fill 40, i
  }
}
shiftScreenRightTop:  .namespace c64lib { _t2_shiftScreenRightTop(@cfg, 0); rts }
