floor=0.4;
led_depth=1.2;
led_length=195;
led_width=10.5;
led_dist=12;
box_size=[195,145];
translate(-box_size/2) cube([box_size[0],box_size[1],floor]);
translate([0,-box_size[1]/2,floor]) rotate([90,0,90])linear_extrude(height=led_length,center=true)
  difference() {
    square([box_size[1],led_depth]);
    for (shift=[led_dist/2:led_dist:box_size[1]-1]) translate([shift,0]) polygon([[-led_width/2,0],[led_width/2,0],[0,led_width/2]]);
  }
  