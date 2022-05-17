const std = @import("std");
const zfetch = @import("zfetch");

/// Used to make HTTP requests and thats it.
pub const HTTPClient = struct {
    const Self = @This();
    alloc: std.mem.Allocator,

    /// Generic function so I don't need so much boilerplate code to send HTTP requests.
    pub fn sendRequest(
        self: Self,
        url: []const u8,
        method: zfetch.Method,
        data: ?[]const u8,
        // Likely inefficient because we go though zfetch' Header type.
        headers: ?std.StringHashMap([]const u8),
    ) ![]const u8 {
        const alloc = self.alloc;
        try zfetch.init();

        var req_headers = zfetch.Headers.init(alloc);
        defer req_headers.deinit();

        if (headers) |header_list| {
            try req_headers.appendValue(key, val);
        }

        defer req_headers.deinit();

        var req = try zfetch.Request.init(alloc, url, null);
        defer req.deinit();

        try req.do(method, headers, data orelse null);

        const body = req.reader().readAllAlloc(
            alloc,
            // This is maybe a bad idea if you requested a lot of data,
            // because it reads until OOM.
            std.math.maxInt(usize),
        );

        defer alloc.free(body);
        return body;
    }

    pub fn init(alloc: std.mem.Allocator) HTTPClient {
        return Self{ .alloc = alloc };
    }
};
