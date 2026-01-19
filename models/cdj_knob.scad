$fs=1/4;
$fa=1/4;
shaft_h=12;
shaft_offset=6;
shaft_d=6;
shaft_cut=1.5;
wall=1.2;
gap=1;
tol=0.0;
depth=0.6;
ld=14;
ud=13;
height=15;
n_feats=16;
module shaft() {
  difference() {
    circle(d=shaft_d);
    translate([-shaft_d/2,-shaft_d/2]) square([shaft_d,shaft_cut]);
  }
}

translate([0,0,-shaft_offset])linear_extrude(height=shaft_h) {
  mirror([0,1]) difference() {
    offset(r=tol+wall) shaft();
    offset(r=tol) shaft();
    translate([-gap/2,-shaft_d/2-tol-wall])square([gap,shaft_d/2+tol+wall]);
    }
}

difference() {
  union() {
    translate([0,0,0])cylinder(d1=ld-2*depth,d2=ud-2*depth,h=15);
    translate([0,0,0])cylinder(d=ld,h=depth);
    for (angle=[360/n_feats:360/n_feats:360-1]) rotate([0,0,angle]) {
      hull() {
        translate([0,ud/2-depth,height-depth]) sphere(r=depth);
        translate([0,ld/2-depth,depth]) cylinder(r=depth,h=1/100); 
      }
    }
  }
  hull() {
    translate([0,ud/2-depth,height]) sphere(r=depth);
    translate([0,0,height]) sphere(r=depth);
  }
  hull() {
    translate([0,ud/2-depth,height]) sphere(r=depth);
    translate([0,ld/2-depth,2*depth]) sphere(r=depth);
  }
  translate([0,0,-1/100])cylinder(d=ud-2*depth-2*wall,h=shaft_offset);
}