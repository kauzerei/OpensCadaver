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
*difference() {
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

module profile(wall,charger_h,phone_h,chamfer,fillet) {
  difference() {
    //square([2*wall,charger_h+phone_h/2]);
    //translate([-wall,charger_h])offset(r=chamfer)offset(r=-chamfer)square([2*wall,phone_h]);
    polygon([[chamfer,0],[2*wall-chamfer,0],[2*wall,chamfer],[2*wall,charger_h+phone_h/2-chamfer],[2*wall-chamfer,charger_h+phone_h/2],
             [wall+chamfer,charger_h+phone_h/2],[wall,charger_h+phone_h/2-chamfer],[wall,charger_h+chamfer],[wall-chamfer,charger_h],
             [chamfer,charger_h],[0,charger_h-chamfer],[0,chamfer]]);
    translate([wall-fillet,charger_h+fillet])circle(r=fillet);
  }
}
module frame(){
  for (i=[0,1], j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) 
  {
    translate([width/2-larger_r,height/2-larger_r])rotate_extrude(angle=90) 
    translate([larger_r-wall,0]) profile(wall,charger_h,thickness,smaller_r,smaller_r);
    translate([width/2-larger_r,height/2-larger_r]) rotate([90,0,0]) linear_extrude(height=height/2-larger_r,convexity=3)
    translate([larger_r-wall,0]) profile(wall,charger_h,thickness,smaller_r,smaller_r);
    translate([0,height/2-larger_r]) rotate([90,0,90]) linear_extrude(height=width/2-larger_r,convexity=3)
    translate([larger_r-wall,0]) profile(wall,charger_h,thickness,smaller_r,smaller_r);
  }
}
module charger_holder(h,d,w,r,l) {
  difference() {
    union() {
      translate([0,0,0])cylinder(d1=d+2*w-2*r,d2=d+2*w,h=r);
      translate([0,0,r])cylinder(d=d+2*w,h=h+w-2*r);
      translate([0,0,h+w-r])cylinder(d1=d+2*w,d2=d+2*w-2*r,h=r);
    }
    translate([0,0,h/2+w/2])cube([l,2*l,h+2*w],center=true);
  }
}
difference() {
  union() {
    frame();
    charger_holder(charger_h,charger_d,wall,smaller_r,width+2*wall-2*smaller_r);
  }
  translate([0,0,-0.01])cylinder(d=charger_d,h=charger_h+thickness);
  rotate([90,0,0]) cylinder(d=14,h=2*height);
}