part="NOSTL_all";//[NOSTL_all,phone_frame,mirror_frame]
width=149;
height=60;
shelf=5;
depth=3;
wall_v=4;
wall_h=2;
hole=3;
glass=3;
bissl=1/100;
beam=2*wall_h+hole;
$fs=1/1;
$fa=1/1;
module chain_hull() {
  for (i = [0:$children-2]) {
    hull() {
      children(i);
      children(i+1);
    }
  }
}

module phone_frame() {
  difference() {
    cube([width+2*shelf+2*wall_v,height+2*shelf+2*wall_v,wall_h+depth]);
    translate([wall_v+shelf,wall_v+shelf,-bissl])cube([width,height,wall_h+2*bissl]);
    translate([wall_v,wall_v,wall_h-bissl])cube([width+2*shelf,height+2*shelf,depth+2*bissl]);
  }
  for(tr=[[-beam/2,beam/2,wall_h/2],
          [width+2*shelf+2*wall_v+beam/2,beam/2,wall_h/2],
          [-beam/2,height+2*shelf+2*wall_v-beam/2,wall_h/2],
          [width+2*shelf+2*wall_v+beam/2,height+2*shelf+2*wall_v-beam/2,wall_h/2]
          ]) translate(tr) difference() {
    cube([beam,beam,wall_h],center=true);
    cylinder(d=hole,h=wall_h+bissl,center=true);
  }
}

module mirror_frame() {
  difference() {
    chain_hull() {
      translate([height+2*shelf+2*wall_v-beam,0,0]) cube(beam);
      translate([0,0,0]) cube(beam);
      translate([0,height+2*shelf+2*wall_v-beam,0]) cube(beam);
      translate([height+2*shelf+2*wall_v-beam,0,0]) cube(beam);
      translate([height+2*shelf+2*wall_v-beam,height+2*shelf+2*wall_v-beam,0]) cube(beam);
      translate([0,height+2*shelf+2*wall_v-beam,0]) cube(beam);
    }
    translate([0,beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
    translate([height+2*shelf+2*wall_v,beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
    translate([0,height+2*shelf+2*wall_v-beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
    translate([height+2*shelf+2*wall_v,height+2*shelf+2*wall_v-beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
  }
  difference() {
    hull() {
      translate([beam,height+2*shelf+2*wall_v-2*beam,beam]) cube([beam,beam,shelf]);
      translate([height+2*shelf+2*wall_v-2*beam,beam,beam]) cube([beam,beam,shelf]);
    }
    hull() {
      translate([beam+glass,height+2*shelf+2*wall_v-2*glass-beam,beam]) cube([glass,glass,beam+bissl]);
      translate([height+2*shelf+2*wall_v-glass,0,beam]) cube([glass,glass,beam+bissl]);
    }
  }
}
 
if (part=="phone_frame") phone_frame();
if (part=="mirror_frame") mirror_frame();
if (part=="NOSTL_all") {
  phone_frame();
  translate([-beam,0,wall_h+1]) mirror([1,0,0]) rotate([0,-90,0]) mirror_frame();
  }