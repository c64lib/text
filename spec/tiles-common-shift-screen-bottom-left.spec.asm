#import "64spec/lib/64spec.asm"
#import "../lib/tiles-screen-shift.asm"

sfspec: init_spec()
  describe("_t2_shiftScreenLeftBottom")

  it("shifts screen to the left/bottom by 1 byte"); {
    jsr shiftScreenLeftBottom

    assert_bytes_equal 1000: testScreenData: expectedScreenData_leftBottom
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
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text " .   .   .   .   .   .   .   .   .   .  "
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text "1234567890123456789012345678901234567890"
}
.print "test data address = " + testScreenData

expectedScreenData_leftBottom: {
  //    "0000011111222223333344444555556666677777"
  .text "1234567890123456789012345678901234567890"
  .text "   .   .   .   .   .   .   .   .   .   ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "  .   .   .   .   .   .   .   .   .   . "
  .text ".   .   .   .   .   .   .   .   .   .  ."
  .text "1234567890123456789012345678901234567890"
}
shiftScreenLeftBottom:  .namespace c64lib { _t2_shiftScreenLeftBottom(@cfg, 0); rts }
