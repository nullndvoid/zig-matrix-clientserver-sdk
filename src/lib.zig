const std = @import("std");
const http = @import("./http.zig");

/// ## Client
/// I am lazy, for now put every endpoint here!
pub const Client = struct {
    const Self = @This();

    // alloc: std.mem.Allocator,
    http_client: http.HTTPClient,

    pub fn getVersions(self: Self) void {
         _ = try self.http_client.sendRequest("http://google.com", .GET, null, null);
    }

    pub fn init(alloc: std.mem.Allocator) Client {
        const http_client = http.HTTPClient.init(alloc);
        return Self{ .http_client = http_client };
    }
};

comptime {
    std.testing.refAllDecls(@This());
}
