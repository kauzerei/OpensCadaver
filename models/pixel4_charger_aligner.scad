$fa=1/1;
$fs=1/2;
width=70;
height=148;
thickness=8;
larger_r=10;
smaller_r=1.5;
charger_d=92;
charger_h=10;
wall=4;
camera=1.5;
module roundbox(w,h,t,r1,r2,fillet) {
  minkowski() {
    linear_extrude(height=t-2*r2) {
      offset(r=r1-r2) offset(r=-r1) square([w,h],center=true);
    }
    if(fillet)translate([0,0,r2]) sphere(r=r2);
    else translate([0,0,r2]) for (i=[0,1]) mirror([0,0,i]) cylinder(d1=r2*2,d2=0,h=r2);
  }
}
module roundcylinder(d,h,r,fillet) {
  minkowski() {
    cylinder(d=d-2*r,h=h-2*r);
    if(fillet)translate([0,0,r]) sphere(r=r);
    else translate([0,0,r]) for (i=[0,1]) mirror([0,0,i]) cylinder(d1=r*2,d2=0,h=r);
  }
}
difference() {
  union() {
    roundbox(width+2*wall,height+2*wall,thickness/2+charger_h,larger_r,smaller_r);
    roundcylinder(charger_d+wall*2,charger_h+thickness/2,smaller_r);
  }
  translate([0,0,charger_h-0.1])roundbox(width,height,thickness,larger_r,smaller_r,true);
  translate([0,0,-camera])cylinder(d=charger_d,h=charger_h);
  for (i=[0,180]) rotate([0,0,i])translate([(63-31)/2,(141-31)/2,charger_h-camera])roundbox(26,26,1.5,5,0);
  translate([0,0,charger_h/2-3]) rotate([90,0,0]) linear_extrude(height=height) {
    square([12,charger_h],center=true);
    //offset(r=smaller_r) offset(r=-smaller_r) square([12,charger_h],center=true);
  }
  intersection() {
    cylinder(d=charger_d,h=charger_h+thickness);
    translate([-width/2,-height/2,0])cube([width,height,charger_h+thickness]);
  }
  translate([0,0,charger_h+thickness/2-smaller_r])roundbox(width+2*smaller_r,height,thickness,larger_r,smaller_r,false);
  cylinder(d1=charger_d/4,d2=charger_d,h=thickness/2+charger_h+0.1);
}