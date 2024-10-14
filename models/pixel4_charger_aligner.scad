$fa=1/1;
$fs=1/2;
width=70;
height=148;
thickness=8;
larger_r=10;
smaller_r=1.5;
charger_d=92;
charger_h=11;
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
    roundbox(width+2*wall,height+2*wall,thickness/2+charger_h+camera,larger_r,smaller_r);
    roundcylinder(charger_d+wall*2,charger_h+thickness/2+camera,smaller_r);
  }
  translate([0,0,charger_h+camera])roundbox(width,height,thickness,larger_r,smaller_r,true);
  translate([0,0,-0.1])cylinder(d=charger_d,h=charger_h+0.1);
  for (i=[0,180]) rotate([0,0,i])translate([(63-31)/2,(141-31)/2,charger_h])roundbox(26,26,camera+0.1,5,0);
  *translate([0,0,charger_h/2]) rotate([90,0,90]) linear_extrude(height=height) {
    square([12,charger_h],center=true);
    //offset(r=smaller_r) offset(r=-smaller_r) square([12,charger_h],center=true);
  }
  intersection() {
    cylinder(d=charger_d,h=charger_h+thickness);
    translate([-width/2,-height/2,0])cube([width,height,charger_h+thickness]);
  }
  translate([0,0,charger_h+thickness/2+camera-smaller_r])roundbox(width+2*smaller_r,height,thickness,larger_r,smaller_r,false);
  cylinder(d1=0,d2=charger_d,h=thickness/2+charger_h+camera+0.1);
  translate([0,0,-0.1])roundbox(width-2*wall,height-2*wall,thickness+charger_h,2*wall,0,true);
  rotate([0,90,90])cylinder(d=10,h=height*2);
}