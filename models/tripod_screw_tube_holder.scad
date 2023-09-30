// Project: camera stabilizer
// Part for mounting the camera to any tube in a secure way
$fn=64/1;
air_gap=0.5;
tube_od=19.5;
tube_id=17.5;
screw_diameter=6;
screw_length_extra=18-5;
screw_head_height=5;
screw_head_size=12.5;
od=tube_od+2*air_gap;
id=tube_id-2*air_gap;
platform_diameter=30;
platform_height=3;
fix_holes=3;
difference() {
  union() {
    cylinder(d=platform_diameter,h=platform_height);
    cylinder(h=screw_length_extra+screw_head_height,d=id);
    difference() {
      translate([0,0,platform_height])cylinder(d1=platform_diameter,d2=od,h=screw_length_extra+screw_head_height-platform_height);
      cylinder(h=screw_length_extra+screw_head_height,d=od);
    }
  }
  cylinder(h=screw_length_extra+screw_head_height,d=screw_diameter+2*air_gap);
  translate([0,0,screw_length_extra])cylinder($fn=6,h=screw_head_height,d=screw_head_size+2*air_gap);
  for (angle=[0:120:240]) {
    translate([0,0,screw_length_extra-fix_holes/2-2])rotate([90,0,angle])cylinder(d=fix_holes,h=platform_diameter);
  }
}