const w4 = @import("wasm4.zig");
const std = @import("std");
const global = @import("globals.zig");

const Vec2D = struct {
    x: i32,
    y: i32,
};

pub const Tileset = struct {
    tileset: []const u8,

    /// Dimensions are in tiles, not px
    width: u32,
    height: u32,

    pub fn init(tileset: []const u8, width: u32, height: u32) Tileset {
        return .{
            .tileset = tileset,
            .width = width,
            .height = height,
        };
    }

    // TODO: boundary check index
    pub fn getTileCoords(self: Tileset, index: u32) struct { x: u32, y: u32 } {
        return .{
            .x = @rem((index - 1), self.width) * global.TILE_SIZE,
            .y = @divTrunc((index - 1), self.width) * global.TILE_SIZE,
        };
    }
};

pub const Tilegrid = struct {
    tilegrid: []const u8,

    /// Dimensions are in tiles, not px
    width: u32,
    height: u32,

    pub fn init(tilegrid: []const u8, width: u32, height: u32) Tilegrid {
        return .{
            .tilegrid = tilegrid,
            .width = width,
            .height = height,
        };
    }
};

pub const Tilemap = struct {
    tileset: Tileset,
    tilegrid: Tilegrid,

    pub fn init(tileset: Tileset, tilegrid: Tilegrid) Tilemap {
        return .{
            .tileset = tileset,
            .tilegrid = tilegrid,
        };
    }

    // x and y are where the camera is respective to the world
    pub fn draw(self: Tilemap, x: i32, y: i32) void {
        var row: u8 = 0;
        var column: u8 = 0;

        for (self.tilegrid.tilegrid) |tile| {
            if (tile != 0) {

                // calculate the camera relative positions of world tiles
                const tile_loc: Vec2D = .{
                    .x = (@as(i32, global.TILE_SIZE) * column) - x,
                    .y = (@as(i32, global.TILE_SIZE) * row) - y,
                };

                const src_loc = self.tileset.getTileCoords(tile);

                w4.blitSub(
                    self.tileset.tileset.ptr,
                    tile_loc.x,
                    tile_loc.y,
                    global.TILE_SIZE,
                    global.TILE_SIZE,
                    src_loc.x,
                    src_loc.y,
                    (self.tileset.width * global.TILE_SIZE),
                    w4.BLIT_2BPP,
                );
            }

            // iterate through the shape of the map
            column += 1;

            if (column == self.tilegrid.width) {
                column = 0;
                row += 1;
            }
        }
    }
};
