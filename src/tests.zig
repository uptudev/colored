const std = @import("std");
const colored = @import("root.zig");
const testing = std.testing;

test "basic add functionality" {
    try testing.expect(colored.add(3, 7) == 10);
}
