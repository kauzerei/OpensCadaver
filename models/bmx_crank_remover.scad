$fs=1/2;
$fa=1/2;
dent_depth=1.5;
dent_width=4;
od=44.5;
coupling_depth=4;
hole=20;
wall=5;
wrench=24;
wrench_width=8;
wrench_d=wrench*2/sqrt(3);
bissl=1/100;
transition_height=max([((od+2*wall)-wrench)/2,
                       ((od+2*wall)-hole)/2]);
difference() {
  cylinder(d=od+2*wall,h=coupling_depth+wall);
  translate([0,0,-bissl])cylinder(d=od,h=coupling_depth+wall+2*bissl);
}
difference() {
  hull() {
    translate([0,0,coupling_depth+wall]) cylinder(d=od+2*wall,h=bissl);
    translate([0,0,coupling_depth+wall+transition_height]) cylinder($fn=6,d=wrench_d,h=bissl);
  }
  translate([0,0,coupling_depth+wall-bissl]) cylinder(d1=od,d2=hole, h=transition_height+3*bissl);
}
difference() {
  translate([0,0,coupling_depth+wall+transition_height]) cylinder($fn=6,d=wrench_d,h=wrench_width);
  translate([0,0,coupling_depth+wall+transition_height-bissl]) cylinder(d=hole,h=wrench_width+2*bissl);
}
for (a=[0:60:300]) rotate([0,0,a]) translate([-dent_depth-od/2,-dent_width/2,0]) cube([dent_depth*2,dent_width,coupling_depth]);