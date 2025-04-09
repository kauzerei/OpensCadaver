$fs=1/2;
$fa=1/2;
bissl=1/100;
vd=22;
ih=3; //height of vent inside collar
oh=5; //collar height
td=7; //mouthpiece width
w=2; //wall
v=3; //vent depth
s=1; //shift of vent geometry
ms=10; //mouthpiece length
hole=2;
sq=sqrt(2)/2;
difference() {
  translate([-oh/2,-vd/2-v-w,0])cube([oh,vd+2*v+2*w,vd+3*w+hole]);
  translate([0,0,vd/2+w])rotate([0,90,0]) cylinder(h=oh+bissl,d=vd,center=true);
  translate([-oh/2-bissl,-vd*sq/2,w+vd/2]) cube([oh+2*bissl,vd*sq,vd/2+2*w+hole+bissl]);
  translate([0,0,2*w+vd])rotate([90,0,0])cylinder(d=hole,h=vd+2*v+2*w+bissl,center=true);
  translate([0,0,-bissl])linear_extrude(height=w+vd/2+vd*sq-v-vd/2-s+2*bissl, scale=[1,1]) square([ih,vd+2*v],center=true);
  translate([0,0,w+vd/2+vd*sq-v-vd/2-s])linear_extrude(height=vd/2+v, scale=[1,0]) square([ih,vd+2*v],center=true);
}
h=-((td+2*w)-(vd+2*v+2*w))/2;
mirror([0,0,1]) difference() {
  linear_extrude(height=h,scale=[(td+2*w)/oh,(td+2*w)/(vd+2*v+2*w)]) square([oh,vd+2*v+2*w],center=true);
  translate([0,0,-bissl])linear_extrude(height=h+2*bissl,scale=[td/ih,td/(vd+2*v)]) square([ih,vd+2*v],center=true);
  }
//outer: oh->td+2*w vd+2*v+2*w->td+2*w
//inner: ih->td vd+2*v->td
translate([0,0,-h-ms]) difference() {
//cylinder(h=ms,d=td+2*w);
translate([-td/2-w,-td/2-w,0])cube([td+2*w,td+2*w,ms]);
translate([0,0,-bissl])cylinder(h=ms+2*bissl,d=td);
}
