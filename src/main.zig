const w4 = @import("wasm4.zig");
const std = @import("std");

export fn start() void {
    w4.PALETTE.* = .{
        0xe0f8cf,
        0x86c06c,
        0x306850,
        0x071821,
    };
}

export fn update() void {}
