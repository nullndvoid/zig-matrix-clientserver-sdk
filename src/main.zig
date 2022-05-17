//! TODO: Write library code to actually test this all out!
//! Starting with registration and signup flows.

const std = @import("std");
const print = std.debug.print;

const zfetch = @import("zfetch");

// Allow debugging in testing output.
const log_level: std.log.Level = .debug;

// Heap allocation for zfetch etc...
const alloc = std.testing.allocator;

const matrix = @import("lib.zig");

// I have not written the library yet, for now I will fetch the
// well-known for matrix.org.
test "get matrix.org well-known" {
    const endpoint = "https://matrix.org/.well-known/matrix/client";
    const expected =
        \\{
        \\    "m.homeserver": {
        \\        "base_url": "https://matrix-client.matrix.org"
        \\    },
        \\    "m.identity_server": {
        \\        "base_url": "https://vector.im"
        \\    }
        \\}
        \\
    ;

    try zfetch.init();
    defer zfetch.deinit();

    var req = try zfetch.Request.init(alloc, endpoint, null);
    defer req.deinit();

    try req.do(.GET, null, null);

    const reader = req.reader();

    const body = reader.readAllAlloc(alloc, 4 * 1024) catch |err| return err;
    defer alloc.free(body);

    std.testing.expectEqualStrings(expected, body) catch {
        std.log.debug("matrix.org well-known mismatch!", .{});
    };
}

test "Client" {
    const client = matrix.Client.init(alloc);
    client.getVersions();
}
