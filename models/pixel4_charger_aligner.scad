$fa=1/1;
$fs=1/2;
width=70;
height=148;
thickness=8;
larger_r=10;
smaller_r=3;
charger_d=92;
charger_h=10;
wall=4;
module roundbox(w,h,t,r1,r2) {
  minkowski() {
    linear_extrude(height=t-2*r2) {
      offset(r=r1-r2) offset(r=-r1) square([w,h],center=true);
    }
    translate([0,0,r2]) sphere(r=r2);
  }
}
module roundcylinder(d,h,r) {
  minkowski() {
    cylinder(d=d-2*r,h=h-2*r);
    translate([0,0,r]) sphere(r=r);
  }
}
difference() {
  union() {
    roundbox(width+2*wall,height+2*wall,thickness/2+charger_h,larger_r,smaller_r);
    roundcylinder(charger_d+wall*2,charger_h+thickness/2,smaller_r);
  }
  translate([0,0,charger_h-0.1])roundbox(width,height,thickness,larger_r,smaller_r);
  cylinder(d=charger_d,h=charger_h);
  translate([(63-31)/2,(141-31)/2,charger_h-1.5])roundbox(26,26,1.5,5,0);
  translate([0,0,charger_h/2]) rotate([90,0,0]) linear_extrude(height=height) {
    offset(r=smaller_r) offset(r=-smaller_r) square([12,charger_h],center=true);
  }
}