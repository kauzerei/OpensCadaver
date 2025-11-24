include <../import/BOSL2/std.scad>
include <../import/BOSL2/walls.scad>
thickness=0.4;
width=4;
height=28;
hex_panel([35, 35, height], strut=thickness, spacing=width+2*thickness,frame=0);
//cube([190,120,40]);