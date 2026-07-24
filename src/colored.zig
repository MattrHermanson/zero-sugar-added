// colored.zig
// 80x80 pixels at 2BPP = 20 bytes per row * 80 rows = 1600 bytes total.

pub const colored_sprite =
    // Top half: 40 rows of (10 bytes Color 1 ++ 10 bytes Color 2)
    ([_]u8{0x00} ** 10 ++ [_]u8{0x55} ** 10) ** 40 ++
    // Bottom half: 40 rows of (10 bytes Color 3 ++ 10 bytes Color 4)
    ([_]u8{0xAA} ** 10 ++ [_]u8{0xFF} ** 10) ** 40;
