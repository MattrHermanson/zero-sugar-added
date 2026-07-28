const w4 = @import("wasm4.zig");
const std = @import("std");
const global = @import("globals.zig");

pub const Sheet = struct {
    sheet: []const u8,

    /// Dimensions are in tiles, not px
    width: u32,
    height: u32,

    pub fn init(sheet: []const u8, width: u32, height: u32) Sheet {
        return .{
            .sheet = sheet,
            .width = width,
            .height = height,
        };
    }

    pub fn getTileSrc(self: Sheet, index: u32) struct { x: u32, y: u32 } {
        return .{
            .x = @rem((index - 1), self.width) * global.TILE_SIZE,
            .y = @divTrunc((index - 1), self.width) * global.TILE_SIZE,
        };
    }
};

pub const Grid = struct {
    grid: []const u8,

    /// Dimensions are in tiles, not px
    width: u32,
    height: u32,

    pub fn init(grid: []const u8, width: u32, height: u32) Grid {
        return .{
            .grid = grid,
            .width = width,
            .height = height,
        };
    }
};

pub const Tilemap = struct {
    sheet: Sheet,
    grid: Grid,

    pub fn init(sheet: Sheet, grid: Grid) Tilemap {
        return .{
            .sheet = sheet,
            .grid = grid,
        };
    }

    // x and y are where the camera is respective to the world
    pub fn draw(self: Tilemap, x: i32, y: i32) void {
        var row: u8 = 0;
        var column: u8 = 0;

        for (self.grid.grid) |tile| {
            if (tile != 0) {

                // calculate the camera relative positions of world tiles
                const tile_loc: global.Vec2D = .{
                    .x = (@as(i32, global.TILE_SIZE) * column) - x,
                    .y = (@as(i32, global.TILE_SIZE) * row) - y,
                };

                const src_loc = self.sheet.getTileSrc(tile);

                w4.DRAW_COLORS.* = 0x0234;
                w4.blitSub(
                    self.sheet.sheet.ptr,
                    tile_loc.x,
                    tile_loc.y,
                    global.TILE_SIZE,
                    global.TILE_SIZE,
                    src_loc.x,
                    src_loc.y,
                    (self.sheet.width * global.TILE_SIZE),
                    w4.BLIT_2BPP,
                );
            }

            // iterate through the shape of the map
            column += 1;

            if (column == self.grid.width) {
                column = 0;
                row += 1;
            }
        }
    }
};
