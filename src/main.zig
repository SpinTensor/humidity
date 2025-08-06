const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();

fn vapor_pressure(rel_humid: f64, t_kelvin: f64) f64 {
    const crit_p_h2o: f64 = 22.064 * 1.0e6;
    const crit_t_h2o: f64 = 647.096;
    const a1: f64 = -7.85951783;
    const a2: f64 = 1.84408259;
    const a3: f64 = -11.7866497;
    const a4: f64 = 22.6807411;
    const a5: f64 = -15.9618719;
    const a6: f64 = 1.80122502;
    const tau: f64 = 1.0 - t_kelvin / crit_t_h2o;
    const sat_vp = crit_p_h2o * @exp(crit_t_h2o / t_kelvin * (a1 * std.math.pow(f64, tau, 1.0) +
        a2 * std.math.pow(f64, tau, 1.5) +
        a3 * std.math.pow(f64, tau, 3.0) +
        a4 * std.math.pow(f64, tau, 3.5) +
        a5 * std.math.pow(f64, tau, 4.0) +
        a6 * std.math.pow(f64, tau, 7.5)));
    return sat_vp * rel_humid / 100.0;
}

fn saturation(t_kelvin: f64) f64 {
    const vp = vapor_pressure(100.0, t_kelvin);
    const water_vapor_gas_const = 461.5;
    return vp / (t_kelvin * water_vapor_gas_const);
}

pub fn main() !void {
    var t: f64 = -10.0;
    while (t <= 40.0) : (t += 0.1) {
        try stdout.print("{d:6.2}", .{t});
        const sat = saturation(t + 273.15) * 1000.0;
        var percentage: f64 = 10.0;
        while (percentage <= 100.0) : (percentage += 10.0) {
            try stdout.print(" {d:10.6}", .{sat * percentage / 100.0});
        }
        try stdout.print("\n", .{});
    }
}
