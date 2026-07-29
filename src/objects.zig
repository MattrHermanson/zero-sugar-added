const w4 = @import("wasm4.zig");
const std = @import("std");
const global = @import("globals.zig");

// In world image
pub const Sprite = struct {
    sprite: []const u8,

    /// Width & height are in px
    width: u32,
    height: u32,
    pos: global.Vec2D,

    pub fn init(sprite: []const u8, width: u32, height: u32, x: i32, y: i32) Sprite {
        return .{
            .sprite = sprite,
            .width = width,
            .height = height,
            .pos = .{
                .x = x,
                .y = y,
            },
        };
    }

    pub fn move(self: *Sprite, new_pos: global.Vec2D) void {
        self.pos = new_pos;
    }

    pub fn draw(self: Sprite) void {
        w4.DRAW_COLORS.* = 0x4444; // TODO: draw colors is hard coded
        w4.blit(
            self.sprite.ptr,
            self.pos.x,
            self.pos.y,
            self.width,
            self.height,
            w4.BLIT_1BPP, // TODO: switch to 2BPP
        );
    }
};
