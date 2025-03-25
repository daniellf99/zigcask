const std = @import("std");

pub fn main() !void {
    addValue() catch |err| {
        std.debug.print("Caught error: {}\n", .{err});
    };
    getValue() catch |err| {
        std.debug.print("Caught error: {}\n", .{err});
    };
}

fn addValue() !void {
    const file = try std.fs.cwd().createFile("data.csv", .{ .truncate = false });
    defer file.close();

    try file.seekFromEnd(0);
    try file.writeAll("Hello,Zig\n");
}

fn getValue() !void {
    const file = try std.fs.cwd().createFile("data.csv", .{ .truncate = false, .read = true });
    defer file.close();

    const allocator = std.heap.page_allocator;
    const buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);
    
    const bytesRead = try file.readAll(buffer);
    var printBuffer: []u8 = undefined;
    if (bytesRead < 4096) {
        std.debug.print("Bytes read: {}\n", .{bytesRead});
        printBuffer = buffer[0..bytesRead];
    } else {
        printBuffer = buffer;
    }

    _ = try std.io.getStdOut().write(printBuffer);
}