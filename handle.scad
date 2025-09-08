include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

back=[[0, 0], [12, 0], [25, 0], [33, 0], [47, 4], [57, 8], [72, 11], [83, 11], [100, 8]];
front=[[0, 10], [12, 5], [25, 8], [33, 7], [47, 12], [57, 10], [72, 15], [83, 13], [100, 18]];
smooth_back=smooth_path(back);