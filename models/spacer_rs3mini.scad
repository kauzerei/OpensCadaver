/* Project: camera stab
spacer for dji rs3 mini for better contact with quick-release plate */
$fn=64;
depth=2;
wall=2;

plate_width=60;
plate_length=120;
rb=2;

dji_width=34.7;
dji_length=51.2;
rs=0.7;
difference() {
  hull() for (i=[-plate_width/2-rb,plate_width/2+rb]) for (j=[-plate_length/2-rb,plate_length/2+rb]) translate([j,i])cylinder(h=depth+wall,r=rb);
  minkowski() {
    translate([0,0,wall+rs]) hull() {
      cylinder(d=dji_width-2*rs,h=depth);
      translate([dji_length-dji_width,0,0])cylinder(d=dji_width-2*rs,h=depth);
    }
    sphere(r=rs);
  }
  translate([0,0,-0.01])cylinder(d=8,h=wall+0.02);
}