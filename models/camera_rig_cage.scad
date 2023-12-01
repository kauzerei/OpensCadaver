$fa=1/1;
$fs=1/2;
front=17;
back=17;
left=41;
right=81;
up=70;
bottom=8;
wall=5;
bissl=1/100;
d_hole=4;
d_nut=8;
h_nut=3;
raster=10;
tripod_screw_head=18;
tripod_screw=7;
left_door=[-11,0,10,50]; //format: [start_y,start_z,end_y,end_z], y is lens axis, 0 is at tripod thread
bottom_door=[30,-13,75,14];//format: [start_x,start_y,end_x,end_y], y is lens axis, 0 is at tripod thread
difference() {
  translate([-left-wall,-back,-bottom]) cube([left+right+2*wall,front+back,up+wall+bottom]);
  translate([-left,-back-bissl,0]) cube([left+right,front+back+2*bissl,up]);
  translate([-left-wall-bissl,left_door[0],left_door[1]])cube([wall+2*bissl,left_door[2]-left_door[0],left_door[3]-left_door[1]]);
  translate([bottom_door[0],bottom_door[1],-bottom-bissl])cube([bottom_door[2]-bottom_door[0],bottom_door[3]-bottom_door[1],bottom+2*bissl]);
  //bottom holes
  for (x=[-floor(left/raster-0.5)*raster:raster:right-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      if (x<bottom_door[0]-raster/2 || x>bottom_door[2]+raster/2 || y<bottom_door[1]-raster/2 || y>bottom_door[3]+raster/2)
      translate([x,y,0])rotate([180,0,0])nut_hole(d_hut=d_nut,d_hole=d_hole,depth=bottom,h_nut=max(h_nut,2*bottom/3));
  //top holes
  for (x=[-floor(left/raster-0.5)*raster:raster:right-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      translate([x,y,up])nut_hole(d_hut=d_nut,d_hole=d_hole,h_nut=h_nut,depth=wall);
  //left holes
  for (z=[raster/2:raster:up-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      if (y<left_door[0]-raster/3 || y>left_door[2]+raster/3 || z<left_door[1]-raster/3 || z>left_door[3]+raster/3)
      translate([-left,y,z])rotate([0,-90,0])nut_hole(d_hut=d_nut,d_hole=d_hole,h_nut=h_nut,depth=wall);
  //right holes
  for (z=[raster/2:raster:up-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      translate([right,y,z])rotate([0,90,0])nut_hole(d_hut=d_nut,d_hole=d_hole,h_nut=h_nut,depth=wall);
   translate([0,0,-bottom-bissl])cylinder(d=tripod_screw,h=bottom+2*bissl);
*   translate([0,0,-bottom-bissl])cylinder(d=tripod_screw_head,h=bottom/2+2*bissl);
*translate([0,0,-2])camerashape();
}
module nut_hole(d_hut=8,d_hole=4,h_nut=4,depth=10) {
  translate([0,0,-bissl]) cylinder(h=h_nut+bissl,d=d_nut,$fn=6);
  translate([0,0,-bissl]) cylinder(h=depth+2*bissl,d=d_hole); 
}
module camerashape() {
hull() {
  translate([-31,-11,0])bublik(3,6);
  translate([45,-11,0])bublik(3,6);
  translate([-29,7,0])bublik(3,10);
  translate([63,3,0])bublik(3,20);
  translate([66,-7,0])bublik(3,10);
  }
hull() {
translate([-15,7,0])bublik(3,10);
translate([15,7,0])bublik(3,10);
translate([0,11,0.5])bublik(3,10);
}
translate([0,10,31])rotate([-90,0,0])cylinder(h=10,d=62);
*translate([-50,-50,2])cube([200,100,100]);
module bublik(h,w) {
  minkowski() {
    translate([0,0,h/2])cylinder(d=w-h,h=bissl);
    sphere(r=h/2);
  }
  translate([0,0,h/2])cylinder(h=h/2,d=w);
}
}