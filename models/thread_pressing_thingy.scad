$fa=1/2;
$fs=1/2;
thickness=5;
od=55;
width=35;
tooth=2;
linear_extrude(thickness) {
  intersection() {
    circle(d=od);
    translate([tooth/4,-width/2]) square([od,width]);
  }
}
rotate([90,0,0])linear_extrude(width,center=true) {
  intersection() {
    translate([-tooth/4,0]) square([tooth/2,thickness]);
    for (tr=[0:tooth:thickness]) translate([0,tr]) polygon([[-tooth/4,tooth/2],[tooth/4,tooth],[tooth/4,0]]);
  }
}

/*
id=8;
slices=32;
part="button";//[button,sector]
if (part=="button") {
  cylinder(h=thickness,d=id*2);
  cylinder(h=thickness*2,d=id);
}

if (part=="sector") linear_extrude(thickness) {
  intersection() {
    difference() {
      circle(d=od);
      circle(d=id);
    }
  polygon([[0,0],[od,0],od*[cos(360/slices),sin(360/slices)]]);
  }
}
*/