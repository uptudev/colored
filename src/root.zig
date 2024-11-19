const std = @import("std");
const tty = std.io.tty;
const windows = std.os.windows;
const io = std.io;

pub const Colored = struct {
    str: []const u8,
    color: ?tty.Color = null,
    bg_color: ?tty.Color = null,
    conf: tty.Config = tty.detectConfig(io.getStdErr()),

    pub fn new(str: []const u8) Colored {
        return Colored{ .str = str };
    }

    pub fn render(self: *Colored) []u8 {
        const prefix = set_color(self.conf, self.color, self.bg_color);
        const suffix = set_color(self.conf, tty.Color.reset, tty.Color.reset);
        std.debug.print("{s}{s}{s}\n", .{ prefix, self.str, suffix });
    }

    pub fn reset(self: *Colored) *Colored {
        self.color = tty.Color.reset;
        self.bg_color = null;
        return self;
    }

    pub fn black(self: *Colored) *Colored {
        self.color = tty.Color.black;
        return self;
    }

    pub fn blue(self: *Colored) *Colored {
        self.color = tty.Color.blue;
        return self;
    }

    pub fn green(self: *Colored) *Colored {
        self.color = tty.Color.green;
        return self;
    }

    pub fn cyan(self: *Colored) *Colored {
        self.color = tty.Color.cyan;
        return self;
    }

    pub fn red(self: *Colored) *Colored {
        self.color = tty.Color.red;
        return self;
    }

    pub fn magenta(self: *Colored) *Colored {
        self.color = tty.Color.magenta;
        return self;
    }

    pub fn yellow(self: *Colored) *Colored {
        self.color = tty.Color.yellow;
        return self;
    }

    pub fn white(self: *Colored) *Colored {
        self.color = tty.Color.white;
        return self;
    }

    pub fn bright_black(self: *Colored) *Colored {
        self.color = tty.Color.bright_black;
        return self;
    }

    pub fn bright_blue(self: *Colored) *Colored {
        self.color = tty.Color.bright_blue;
        return self;
    }

    pub fn bright_green(self: *Colored) *Colored {
        self.color = tty.Color.bright_green;
        return self;
    }

    pub fn bright_cyan(self: *Colored) *Colored {
        self.color = tty.Color.bright_cyan;
        return self;
    }

    pub fn bright_red(self: *Colored) *Colored {
        self.color = tty.Color.bright_red;
        return self;
    }

    pub fn bright_magenta(self: *Colored) *Colored {
        self.color = tty.Color.bright_magenta;
        return self;
    }

    pub fn bright_yellow(self: *Colored) *Colored {
        self.color = tty.Color.bright_yellow;
        return self;
    }

    pub fn bright_white(self: *Colored) *Colored {
        self.color = tty.Color.bright_white;
        return self;
    }

    pub fn bold(self: *Colored) *Colored {
        self.color = tty.Color.bold;
        return self;
    }

    pub fn dim(self: *Colored) *Colored {
        self.color = tty.Color.dim;
        return self;
    }

    pub fn bg_black(self: *Colored) *Colored {
        self.bg_color = tty.Color.black;
        return self;
    }

    pub fn bg_blue(self: *Colored) *Colored {
        self.bg_color = tty.Color.blue;
        return self;
    }

    pub fn bg_green(self: *Colored) *Colored {
        self.bg_color = tty.Color.green;
        return self;
    }

    pub fn bg_cyan(self: *Colored) *Colored {
        self.bg_color = tty.Color.cyan;
        return self;
    }

    pub fn bg_red(self: *Colored) *Colored {
        self.bg_color = tty.Color.red;
        return self;
    }

    pub fn bg_magenta(self: *Colored) *Colored {
        self.bg_color = tty.Color.magenta;
        return self;
    }

    pub fn bg_yellow(self: *Colored) *Colored {
        self.bg_color = tty.Color.yellow;
        return self;
    }

    pub fn bg_white(self: *Colored) *Colored {
        self.bg_color = tty.Color.white;
        return self;
    }

    pub fn bg_bright_black(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_black;
        return self;
    }

    pub fn bg_bright_blue(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_blue;
        return self;
    }

    pub fn bg_bright_green(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_green;
        return self;
    }

    pub fn bg_bright_cyan(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_cyan;
        return self;
    }

    pub fn bg_bright_red(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_red;
        return self;
    }

    pub fn bg_bright_magenta(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_magenta;
        return self;
    }

    pub fn bg_bright_yellow(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_yellow;
        return self;
    }

    pub fn bg_bright_white(self: *Colored) *Colored {
        self.bg_color = tty.Color.bright_white;
        return self;
    }
};

// fork of `std.io.tty.Config.setColor`, which is incomplete
fn set_color(
    conf: *tty.Config,
    color: ?tty.Color,
    bg_color: ?tty.Color,
) windows.SetConsoleTextAttributeError!(?[]u8) {
    nosuspend switch (conf) {
        .no_color => return,
        .escape_codes => {
            var buffer: [16]u8 = undefined;
            var index: usize = 0;
            const prefix = "\x1b[";
            for (prefix) |c| {
                buffer[index] = c;
                index += 1;
            }
            const color_string = switch (color) {
                .black => "30",
                .red => "31",
                .green => "32",
                .yellow => "33",
                .blue => "34",
                .magenta => "35",
                .cyan => "36",
                .white => "37",
                .bright_black => "90",
                .bright_red => "91",
                .bright_green => "92",
                .bright_yellow => "93",
                .bright_blue => "94",
                .bright_magenta => "95",
                .bright_cyan => "96",
                .bright_white => "97",
                .bold => "1",
                .dim => "2",
                .reset => {
                    return "\x1b[0m";
                },
                null => "",
            };
            for (color_string) |c| {
                buffer[index] = c;
                index += 1;
            }
            const bg_string = switch (bg_color) {
                .black => "40",
                .red => "41",
                .green => "42",
                .yellow => "43",
                .blue => "44",
                .magenta => "45",
                .cyan => "46",
                .white => "47",
                .bright_black => "100",
                .bright_red => "101",
                .bright_green => "102",
                .bright_yellow => "103",
                .bright_blue => "104",
                .bright_magenta => "105",
                .bright_cyan => "106",
                .bright_white => "107",
                .bold => "1",
                .dim => "2",
                .reset => {
                    return "\x1b[0m";
                },
                null => "",
            };
            for (bg_string) |c| {
                buffer[index] = c;
                index += 1;
            }
            // insert prefix into buffer
            // insert color_string into buffer
            //if (color != null and bg_color != null) {
            // insert ; into buffer
            //};
            // insert bg_string into buffer
            // insert m into buffer
        },
        .windows_api => |ctx| if (tty.native_os == .windows) {
            const attr = win_fmt_code(color, bg_color, ctx.reset_attributes);
            try windows.SetConsoleTextAttribute(ctx.handle, attr);
            return null;
        } else {
            unreachable;
        },
    };
}

// LSB -> MSB
// First 3 bits are the text color (BGR)
// Fourth bit is the text intensity toggle
// Next 3 bits are the background color (BGR)
// Eighth bit is the background intensity toggle
fn win_fmt_code(c: tty.Color, bg: tty.Color, reset_attributes: u16) u16 {
    const code: ?u16 = switch (c) {
        .black => 0x0,
        .blue => 0x1,
        .cyan => 0x3,
        .green => 0x2,
        .red => 0x4,
        .magenta => 0x5,
        .yellow => 0x6,
        .white => 0x7,
        .bright_black, .dim => 0x8,
        .bright_blue => 0x9,
        .bright_green => 0xA,
        .bright_cyan => 0xB,
        .bright_red => 0xC,
        .bright_magenta => 0xD,
        .bright_yellow => 0xE,
        .bright_white, .bold => 0xF,
        .reset => return reset_attributes,
    };
    return switch (bg) {
        .black => code,
        .blue => code | 0x10,
        .cyan => code | 0x30,
        .green => code | 0x20,
        .red => code | 0x40,
        .magenta => code | 0x50,
        .yellow => code | 0x60,
        .white => code | 0x70,
        .bright_black, .dim => code | 0x80,
        .bright_blue => code | 0x90,
        .bright_green => code | 0xA0,
        .bright_cyan => code | 0xB0,
        .bright_red => code | 0xC0,
        .bright_magenta => code | 0xD0,
        .bright_yellow => code | 0xE0,
        .bright_white => code | 0xF0,
        .reset => reset_attributes,
    };
}
