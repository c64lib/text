#import "common/lib/invoke.asm"
#import "chipset/lib/vic2.asm"
#importonce
.filenamespace c64lib

.macro incText(text, count) {
  // thank you Alex Goldblat!
  .fill text.size(), text.charAt(i) + count
}
.assert "incText", { incText("ab", 1)} , { .text "bc" }

// Hosted subroutines

