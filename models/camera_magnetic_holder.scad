//Holder for a phone and a mirror to reflect the screen.
//Project: magnetic mounting system for making videos on a table surface
part="NOSTL_all";//[NOSTL_all,phone_frame,mirror_frame,mirror_frame_mirrored,top_bracket,filter_holder]
width=149;
height=74;
shelf=4;
depth=4;
wall_v=4;
wall_h=2;
hole=4;
glass=3;
bissl=1/100;
beam=2*wall_h+hole;
filter_size=[50,50];
filter_placement=[32,41];
fp=[filter_placement[0],filter_placement[1],wall_h/2];
$fs=1/1;
$fa=1/1;
screws=[[-beam/2,beam/2,wall_h/2],
          [width+2*wall_v+beam/2,beam/2,wall_h/2],
          [-beam/2,height+2*wall_v-beam/2,wall_h/2],
          [width+2*wall_v+beam/2,height+2*wall_v-beam/2,wall_h/2]];

module chain_hull() {
  for (i = [0:$children-2]) {
    hull() {
      children(i);
      children(i+1);
    }
  }
}

module pairwise_hull() {
  for (i=[0:$children-1]) for (j=[0:i]) hull() {
    children(i);
    children(j);
  }
}

module phone_frame() {
  difference() {
    cube([width+2*wall_v,height+2*wall_v,wall_h+depth]);
    translate([wall_v+shelf,wall_v+shelf,-bissl])cube([width-2*shelf,height-2*shelf,wall_h+2*bissl]);
    translate([wall_v,wall_v,wall_h-bissl])cube([width,height,depth+2*bissl]);
  }
  for(tr=screws) translate(tr) difference() {
    cube([beam,beam,wall_h],center=true);
    cylinder(d=hole,h=wall_h+bissl,center=true);
  }
}

module mirror_frame() {
  difference() {
    chain_hull() {
      translate([height+2*wall_v-beam,0,0]) cube(beam);
      translate([0,0,0]) cube(beam);
      translate([0,height+2*wall_v-beam,0]) cube(beam);
      translate([height+2*wall_v-beam,height+2*wall_v-beam,0]) cube(beam);
      translate([height+2*wall_v-beam,beam,0]) cube(beam);
      translate([beam,height+2*wall_v-beam,0]) cube(beam);
    }
    translate([0,beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
    translate([height+2*wall_v,beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
    translate([0,height+2*wall_v-beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
    translate([height+2*wall_v,height+2*wall_v-beam/2,beam/2]) rotate([0,90,0]) cylinder(d=hole,h=20,center=true);
  }
  difference() {
    hull() {
      translate([beam,beam+height+2*wall_v-2*beam,beam]) cube([beam,beam,wall_v]);
      translate([beam+height+2*wall_v-2*beam,beam,beam]) cube([beam,beam,wall_v]);
    }
    hull() {
      translate([beam+glass,beam+height+2*wall_v-2*glass-beam,beam]) cube([glass,glass,beam+bissl]);
      translate([beam+height+2*wall_v-glass,0,beam]) cube([glass,glass,beam+bissl]);
    }
  }
}

module top_bracket() {
  difference() {
    chain_hull() {
      translate(screws[0]) cube([beam,beam,wall_h],center=true);
      translate(screws[1]) cube([beam,beam,wall_h],center=true);
      translate(screws[2]) cube([beam,beam,wall_h],center=true);
      translate(screws[3]) cube([beam,beam,wall_h],center=true);
      translate(screws[0]) cube([beam,beam,wall_h],center=true);
      translate(screws[2]) cube([beam,beam,wall_h],center=true);
      translate(screws[1]) cube([beam,beam,wall_h],center=true);
      translate(screws[3]) cube([beam,beam,wall_h],center=true);
    }
    for (tr=screws) translate(tr) cylinder(d=hole,h=wall_h+bissl,center=true);
  }
}

module filter_holder() {
  difference() {
    union() {
      chain_hull() {
        translate(screws[0]) cube([beam,beam,2*wall_h],center=true);
        translate(fp) cube([beam,beam,2*wall_h],center=true);
        translate(screws[0]) cube([beam,beam,2*wall_h],center=true);
        translate(screws[1]) cube([beam,beam,2*wall_h],center=true);
        translate(fp) cube([beam,beam,2*wall_h],center=true);
        translate(screws[1]) cube([beam,beam,2*wall_h],center=true);
        translate(screws[3]) cube([beam,beam,2*wall_h],center=true);
        translate(fp) cube([beam,beam,2*wall_h],center=true);
        translate(screws[3]) cube([beam,beam,2*wall_h],center=true);
        translate(screws[2]) cube([beam,beam,2*wall_h],center=true);
        translate(fp) cube([beam,beam,2*wall_h],center=true);
        translate(screws[2]) cube([beam,beam,2*wall_h],center=true);
        translate(screws[0]) cube([beam,beam,2*wall_h],center=true);
      }
      translate(fp) cube([filter_size[0]+2*wall_v,filter_size[1]+2*wall_v,2*wall_h],center=true);
    }
    translate(fp) cube([filter_size[0]-2*shelf,filter_size[1]-2*shelf,3*wall_h],center=true);
    translate([0,0,wall_h])translate(fp) cube([filter_size[0],filter_size[1],2*wall_h],center=true);
    for (tr=screws) translate(tr) cylinder(d=hole,h=2*wall_h+bissl,center=true);

  }
}

module power_distributor() {

}

if (part=="phone_frame") phone_frame();
if (part=="mirror_frame") mirror_frame();
if (part=="mirror_frame_mirrored") mirror([1,0,0])mirror_frame();
if (part=="top_bracket") top_bracket();
if (part=="filter_holder") filter_holder();
if (part=="power_distributor") power_distributor();
if (part=="NOSTL_all") {
  phone_frame();
  translate([-beam,0,wall_h+1]) mirror([1,0,0]) rotate([0,-90,0]) mirror_frame();
  translate([0,0,height+2*wall_v+wall_h+2])top_bracket();
  }