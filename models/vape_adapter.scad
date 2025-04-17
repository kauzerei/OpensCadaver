//Adapter for vape that allows blowing out smoke without inhaling
//Project: tiny smoke machine for smoke tests, photos, videos
$fs=1/2;
$fa=1/2;
bissl=1/100;
vape_diameter=21;
vd=vape_diameter; //diameter of part where vents are
vent_width=2;
ih=vent_width; //height of vent inside collar
collar_height=5;
oh=collar_height; //height of part where vents are
mouthpiece_hole=10;
td=mouthpiece_hole; //mouthpiece width
vertical_wall=2;
w=vertical_wall; //wall around mouthpiece and around collar, other walls are thinner
air_channel=3;
v=air_channel; //vent depth
shift=1;
s=shift; //shift of vent geometry, defines seal width
mouthpiece_length=10;
ms=mouthpiece_length; //mouthpiece length
rounded_mouthpiece=false;
tightening_screw=false; //produce geometry for a tightening screw, rely on tight fit if false
tightening_screw_d=2;
hole=tightening_screw_d;
sq=sqrt(2)/2;
difference() {
  translate([-oh/2,-vd/2-v-w,0])cube([oh,vd+2*v+2*w,vd+w+(tightening_screw?(2*w+hole):0)]);
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
  hull() {
    cylinder(h=ms,d=td+2*w);
    if(!rounded_mouthpiece) translate([-td/2-w,-td/2-w,0])cube([td+2*w,td+2*w,ms]);
    translate([-td/2-w,-td/2-w,ms])cube([td+2*w,td+2*w,bissl]);

  }
  translate([0,0,-bissl])cylinder(h=ms+3*bissl,d=td);
}
