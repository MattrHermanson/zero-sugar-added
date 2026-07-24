// checkered.zig
// 160x160 pixels at 1BPP = 20 bytes per row * 160 rows = 3200 bytes total.

pub const checkered_sprite =
    // Alternate Row A (0xAA) and Row B (0x55), 20 bytes each
    ([_]u8{0xAA} ** 20 ++ [_]u8{0x55} ** 20)
    // Repeat that two-row pair 80 times to get 160 rows
    ** 80;
