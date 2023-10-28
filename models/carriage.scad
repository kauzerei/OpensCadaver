$fa=1/1;
$fs=0.1/1;
bissl=0.01;
air=0.5;

//bearing
bearing_h=7;
id=8;
od=22;
//eccentric
nut_d=18;
//nut_h=10;
lip_h=1;
lip_w=2;
offset=2;
//hardware
item=50;
dd=15; //driving distance
free_space=2; // distance from rail
nut_h=dd-bearing_h/2-lip_h+free_space;
bolt_d=4;
//plate
h=4;
d=10;
x=item+od;
wall=2;
module plate(h=4,d=10,x=x) {
  difference() {
    cube([x+d+2*h,x+d+2*h,h]);
    translate([x+d/2+h,x/2+d/2+h,-bissl]) cylinder(h=h+2*bissl,d=d+air);
    translate([h+d/2,h+d/2,-bissl]) cylinder(h=h+2*bissl,d=d+air);
    translate([h+d/2,x+d/2+h,-bissl]) cylinder(h=h+2*bissl,d=d+air);
    for (trans=[[item-dd+od/2+d/2+h,od/2+2+h,0],[dd+od/2+d/2+h,x/2+d/2+h,0],[item-dd+od/2+d/2+h,x+d+h-od/2-2-h,0]]) 
      translate(trans) translate([0,0,h-od/2+free_space]) rotate([0,90,0]) cylinder(d=od+4,h=bearing_h+2*lip_h,center=true);
  }
  for (trans=[[item-dd+od/2+d/2+h,od/2+2+h,0],[dd+od/2+d/2+h,x/2+d/2+h,0],[item-dd+od/2+d/2+h,x+d+h-od/2-2-h,0]])
        translate(trans)bearing_holder(bearing_h=bearing_h,id=id,od=od,h=h-od/2+free_space,wall=wall,lip_h=lip_h,lip_w=lip_w);
}
module bearing_holder(bearing_h=7,id=8,od=22,h=-10,wall=2,lip_h=1,lip_w=2,bolt_d=bolt_d) {
  difference() {
    intersection() {
      union() {
        translate([bearing_h/2+lip_h,0,0]) hull() {
          translate([0,0,h])rotate([0,90,0]) cylinder(d=id+2*lip_w,h=wall);
          translate([wall/2,0,0])cube([wall,max(id+2*lip_w,abs(2*h)),bissl],center=true);
        }
        translate([-bearing_h/2-lip_h-wall,0,0])hull() {
          translate([0,0,h])rotate([0,90,0]) cylinder(d=id+2*lip_w,h=wall);
          translate([wall/2,0,0])cube([wall,max(id+2*lip_w,abs(2*h)),bissl],center=true);
        }
        translate([0,0,h]) rotate([0,90,0]) cylinder(d=id+2*lip_w,h=bearing_h+2*lip_h,center=true);
      }
      translate([0,0,-5*od])cube([10*od,10*od,10*od],center=true);
    }
    translate([0,0,h]) rotate([0,90,0]) cylinder(d=id+2*lip_w+bissl,h=bearing_h,center=true);
    translate([0,0,h]) rotate([0,90,0]) cylinder(d=bolt_d,h=bearing_h+2*lip_h+2*wall+bissl,center=true);
  }
}

module eccentric(nut_d=18,nut_h=10,bolt_d=4,bearing_h=7,id=8,od=22,lip_h=1, lip_w=2,offset=2,h=4,d=10) {
  difference() {
    union() {
      cylinder($fn=6, h=nut_h, d=nut_d);
      translate([offset,0,nut_h])cylinder(d=id+2*lip_w,h=lip_h);
      translate([offset,0,nut_h+lip_h])cylinder(d=id,h=bearing_h);
      translate([0,0,-h])cylinder(d=d,h=h);
    }
  translate([offset,0,-h-bissl])cylinder(d=bolt_d,h=nut_h+lip_h+bearing_h+h+2*bissl);
  }
}
module post(nut_d=18,nut_h=10,bolt_d=4,bearing_h=7,id=8,od=22,lip_h=1, lip_w=2,h=4,d=10) {
  difference() {
    union() {
      cylinder(d=id+2*lip_w,h=lip_h+nut_h);
      translate([0,0,nut_h+lip_h])cylinder(d=id,h=bearing_h);
      translate([0,0,-h])cylinder(d=d,h=h);
    }
  translate([0,0,-h-bissl])cylinder(d=bolt_d,h=nut_h+lip_h+bearing_h+h+2*bissl);
  }
}


translate([0,0,-h])plate();
translate([x+d/2+h,x/2+d/2+h,0]) eccentric(nut_d=nut_d,nut_h=nut_h,bolt_d=bolt_d,bearing_h=bearing_h,id=id,od=od,lip_h=lip_h, lip_w=lip_w,offset=offset,h=h,d=d);
translate([h+d/2,h+d/2,0]) post(nut_d=nut_d,nut_h=nut_h,bolt_d=bolt_d,bearing_h=bearing_h,id=id,od=od,lip_h=lip_h, lip_w=lip_w,h=h,d=d);
translate([h+d/2,x+d/2+h,0]) post(nut_d=nut_d,nut_h=nut_h,bolt_d=bolt_d,bearing_h=bearing_h,id=id,od=od,lip_h=lip_h, lip_w=lip_w,h=h,d=d);