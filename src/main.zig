const w4 = @import("wasm4.zig");
const std = @import("std");

const checkered = @import("checkered.zig");
const colored = @import("colored.zig");
const tilesheet = @import("tilesheet.zig");

// TODO:
// 1. implement 16x16 tile system & indepenent sprite spawning
// 4. player movement - velocity based
// 5. camera system - stays in place until you get close to the edge, stops at world border
// 2. implement entity interface?
// 3. implement collision (entity vs tile & entity vs entity)

// 320 x 320 px map
const map = [_]u8{
    1, 0, // 0: 0x0012
    0, 1, // 1: 0x0034
};

const World = struct {
    map: [4]u8,
    width: i32,
    height: i32,
    tile_size: i32,

    pub fn init(world_map: [4]u8, width: i32, height: i32) World {
        return .{
            .map = world_map,
            .width = width,
            .height = height,
            .tile_size = 160,
        };
    }

    // x and y are where the camera is respective to the world
    pub fn draw(self: World, x: i32, y: i32) void {
        var row: u8 = 0;
        var column: u8 = 0;

        for (self.map) |tile| {

            // calculate the camera relative positions of world tiles
            const tile_x: i32 = (self.tile_size * column) - x;
            const tile_y: i32 = (self.tile_size * row) - y;

            // selectively choose colors  NOTE: a final product would select different tiles
            if (tile == 0) {
                w4.DRAW_COLORS.* = 0x0012;
            } else if (tile == 1) {
                w4.DRAW_COLORS.* = 0x0034;
            }

            w4.blit(&checkered.checkered_sprite, tile_x, tile_y, 160, 160, w4.BLIT_1BPP);

            // iterate through the shape of the map
            column += 1;

            if (column == self.width) {
                column = 0;
                row += 1;
            }
        }

        w4.trace("\n\n");
    }
};

var global_x: i32 = 80;
var global_y: i32 = 80;

const world = World.init(map, 2, 2);

fn input() void {
    const gamepad = w4.GAMEPAD1.*;

    if (gamepad & w4.BUTTON_UP != 0) {
        global_y -= 1;
    }

    if (gamepad & w4.BUTTON_DOWN != 0) {
        global_y += 1;
    }

    if (gamepad & w4.BUTTON_LEFT != 0) {
        global_x -= 1;
    }

    if (gamepad & w4.BUTTON_RIGHT != 0) {
        global_x += 1;
    }
}

export fn start() void {
    w4.PALETTE.* = .{
        0xe0f8cf,
        0x86c06c,
        0x306850,
        0x071821,
    };
}

export fn update() void {
    // input();
    // world.draw(global_x, global_y);
    w4.DRAW_COLORS.* = 0x2340;
    w4.blit(
        &tilesheet.tilesheet,
        tilesheet.tilesheet_width,
        tilesheet.tilesheet_height,
        64,
        64,
        w4.BLIT_2BPP,
    );

    //blitSub (spritePtr, x, y, width, height, srcX, srcY, stride, flags)#

    w4.blitSub(
        &tilesheet.tilesheet,
        10,
        10,
        16,
        16,
        16,
        0,
        64,
        w4.BLIT_2BPP,
    );
}
