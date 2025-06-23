// A spacer block that offsets two things with hole raster
// Like a cage from tripod plate or something
// Probably should become a part of rig-htsized repo
$fa=1/1;
$fs=1/2;
module camera_spacer() {
  height=12;
  width=50;
  depth=12;
  wall=3;
  rounded=5;
  n_holes=3;
  hole_distance=10;
  d_bolt=4;
  d_nut=0;//8;
  nuts_through=true;
  bolts_offset=4;
  bissl=1/100;
  points=[for (i=[-1,1]) for (j=[-1,1]) [i*(height/2-wall/2),j*(width/2-wall/2)]];
  connections=[[0,1],[2,3],[2,0],[3,1]];//,[1,3],[2,0]];
  difference() {
    for (c=connections) hull() {
      translate(points[c[0]])cylinder (d=wall,h=depth,center=true);
      translate(points[c[1]])cylinder (d=wall,h=depth,center=true);
    }
  for (t=[-hole_distance*(n_holes-1)/2:hole_distance:hole_distance*(n_holes-1)/2])
    translate([0,t,bolts_offset-depth/2]) {
      translate([-height/2-bissl,0,0]) rotate([0,90,0])cylinder(d=d_bolt,h=wall+2*bissl);
      translate([-height/2-bissl+wall/2,0,0])rotate([90,0,90])cylinder(d=d_nut,h=wall+2*bissl,$fn=6);
      translate([height/2-wall-bissl,0,0])rotate([0,90,0])cylinder(d=d_bolt,h=wall+2*bissl);
      translate([height/2-wall-bissl-wall/2,0,0])rotate([90,0,90])cylinder(d=d_nut,h=wall+2*bissl,$fn=6);
      if(nuts_through)translate([-height/2-bissl+wall/2,0,0])rotate([90,0,90])cylinder(d=d_nut,h=height-wall,$fn=6);
      
    }
  }
  difference() {
    translate([-(height-wall)/2,-(width-wall)/2,depth/2-wall])cube([height-wall,width-wall,wall]);
    translate([-(height-4*wall)/2,-(width-4*wall)/2,-bissl+depth/2-wall])cube([height-4*wall,width-4*wall,wall+2*bissl]);
  }
}
camera_spacer();