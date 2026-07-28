const w4 = @import("wasm4.zig");
const std = @import("std");

const checkered = @import("checkered.zig");
const colored = @import("colored.zig");
const world_tileset = @import("tilesheet.zig");
const Tilemap = @import("tilemap.zig");

// TODO:
// 1. implement 16x16 tile system & indepenent sprite spawning
// 4. player movement - velocity based
// 5. camera system - stays in place until you get close to the edge, stops at world border
// 2. implement entity interface?
// 3. implement collision (entity vs tile & entity vs entity)

// 10x10 tile map
var map = [_]u8{
    7, 8, 7, 8, 7, 8, 7, 8, 7, 8,
    8, 7, 8, 7, 8, 7, 8, 7, 8, 7,
    7, 8, 7, 8, 7, 8, 7, 8, 7, 8,
    8, 7, 8, 7, 8, 7, 8, 7, 8, 7,
    7, 8, 7, 8, 7, 8, 7, 8, 7, 8,
    8, 7, 8, 7, 8, 7, 8, 7, 8, 7,
    7, 8, 7, 8, 7, 8, 7, 8, 7, 8,
    8, 7, 8, 7, 8, 7, 8, 7, 8, 7,
    7, 8, 7, 8, 7, 8, 7, 8, 7, 8,
    8, 7, 8, 7, 8, 7, 8, 7, 8, 7,
};

var global_x: i32 = 0;
var global_y: i32 = 0;

const tileset = Tilemap.Tileset.init(&world_tileset.tilesheet, 4, 4);
const tilegrid = Tilemap.Tilegrid.init(map[0..], 10, 10);

const world = Tilemap.Tilemap.init(tileset, tilegrid);

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
    input();
    world.draw(global_x, global_y);
}
