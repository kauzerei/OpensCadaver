bsl=1/100;
$fa=1/2;
$fs=1/2;
hor_c=75;
ver_c=33;
length=30;
angle=20;
wall=3;
bearing_offset=5;
hole=3;
bearing_id=5;
bearing_od=16;
bearing_h=4;
bearing_extra_h=1;
bearing_extra_w=2;
height=ver_c-bearing_od/2+bearing_offset;
part="main";//[main,bearing_holder,NOSTL_all]
module main() {
  difference() {
    union() {
      linear_extrude(height=hor_c+2*wall,center=true) {
        polygon([[0,0],[0,length],[-length*tan(angle),length]]);
      }
      translate([0,0,hor_c/2])cube([height,length,wall]);
      translate([0,0,-hor_c/2-wall])cube([height,length,wall]);
      for (tr=[[height-bearing_offset,length-bearing_offset,hor_c/2+wall],
               [height-bearing_offset,bearing_offset,hor_c/2+wall],
               [height-bearing_offset,length-bearing_offset,-hor_c/2-wall-bearing_extra_h],
               [height-bearing_offset,bearing_offset,-hor_c/2-wall-bearing_extra_h]
              ]) translate(tr) cylinder(d=bearing_id+2*bearing_extra_w,h=bearing_extra_h);
    }
    for (tr=[[height-bearing_offset,length-bearing_offset,0],
             [height-bearing_offset,bearing_offset,0]
            ]) translate(tr) cylinder(d=hole,h=hor_c+2*bearing_extra_h+2*wall+bsl,center=true);

  }
}
module bearing_holder() {
  difference() {
    union() {
      cylinder(d=bearing_id+2*bearing_extra_w,h=wall);
      cylinder(d=bearing_id,h=bearing_h+wall);
    }
    translate([0,0,-bsl]) cylinder(h=bearing_h+wall+2*bsl,d=hole);
  }
}
if (part=="main") {rotate([-90,0,0])main();}
if (part=="bearing_holder") {bearing_holder();}
if (part=="NOSTL_all") {
  rotate([0,90,0]) main();
  rotate([0,90,0]) for (m=[[0,0,0],[0,0,1]]) mirror(m)
  for (tr=[[height-bearing_offset,length-bearing_offset,-hor_c/2-2*wall-bearing_h-bearing_extra_h-1],
           [height-bearing_offset,bearing_offset,-hor_c/2-2*wall-bearing_h-bearing_extra_h-1],
          ]) translate(tr) bearing_holder();
}