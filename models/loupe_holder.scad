//Part of visual aid to explain how camera works
//Used in analog photography workshop
$fn=64;
loupe_d=79;
loupe_h=15;
wall=2;
m=36;//[36,23]
part="adapter";//[adapter,holder]

module loupe_negative(d) {
  cylinder(h=loupe_h,d=d);
  translate([0,-d/2,0])cube([d,d,loupe_h]);
}

if (part=="holder") difference() {
  cylinder(d=loupe_d+2*wall,h=2*loupe_h+2*wall);
  loupe_negative(loupe_d);
  translate([0,0,loupe_h])loupe_negative(loupe_d-2*wall);
  translate([0,0,loupe_h+wall])loupe_negative(loupe_d);
  translate([0,0,2*loupe_h+wall])loupe_negative(loupe_d-2*wall);
}

if (part=="adapter") {
  difference() {
    cylinder(d=loupe_d-1,h=loupe_h-1);
    translate([0,0,wall])cylinder(h=loupe_h,d=loupe_d-1-2*wall);
    translate([0,0,-wall/2])cylinder(d=m,h=wall*2);
    for (a=[0:360/22:360]) rotate([0,0,a]) translate([m/2,-1,-wall/2]) rotate([0,0,40]) cube([4,2,2*wall]);
  }
}