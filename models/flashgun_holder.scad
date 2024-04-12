$fs=1/1;
$fa=1/1;
bissl=1/100;
flash_width=70;
flash_height=40;
clamp_depth=15;
wall=1.6;
filter_thickness=2;

air=3;

arm_thickness=10;
arm_width=20;
arm_length=120;
bolt=4;

window_border=3;
window_width=flash_width+2*window_border;
window_height=flash_height+2*window_border;

filter_border=3;
filter_width=window_width+2*filter_border;
filter_height=window_height+2*filter_border;

holder_border=wall;
holder_height=filter_height+2*holder_border;
holder_width=filter_width+2*holder_border;
holder_depth=2*wall+filter_thickness;
holder_length=holder_height;

clamp_thickness=(holder_height-flash_height)/2;
    
module filter_holder() {
  difference() {
    cube([holder_height,holder_length,arm_thickness]); //mount plate
    for (tr=[
      [clamp_thickness/2,holder_length-clamp_depth/2,-bissl],
      [holder_height-clamp_thickness/2,holder_length-clamp_depth/2,-bissl],
      [holder_height/2,holder_length/2,-bissl]
      ]) translate(tr) cylinder(d=bolt, h=arm_thickness+2*bissl);
  }
  translate([0,0,arm_thickness]) difference() {
  cube([holder_height,holder_depth,holder_width]); //vertical filter_holding_thingy
  translate([holder_border,wall,holder_border])cube([filter_height,filter_thickness, filter_width+holder_border+bissl]);
  translate([filter_border+holder_border,-bissl,filter_border+holder_border])cube([window_height,holder_depth+2*bissl,window_width+filter_border+holder_border+bissl]);
  
  }
}

module clamp() {
  difference() {
    cube([holder_height,holder_width,clamp_depth]);
    translate([clamp_thickness,clamp_thickness,-bissl]) cube([flash_height,flash_width,clamp_depth+2*bissl]);
    for (tr=[
    [clamp_thickness/2,-bissl,clamp_depth/2],
    [holder_height-clamp_thickness/2,-bissl,clamp_depth/2]
    ]) translate(tr) rotate([-90,0,0]) cylinder (d=bolt,h=holder_width+2*bissl);
    translate([-bissl,holder_width/2+air/2,-bissl])cube([holder_height+2*bissl,air,clamp_depth+2*bissl]);
  }
}

filter_holder();
translate([0,holder_length,arm_thickness+air])rotate([90,0,0])clamp();
module collar() {
  difference() {
    cube([flash_height+2*holder_thickness,flash_width+2*holder_thickness,holder_depth]);
    translate([holder_thickness,holder_thickness,-bissl])cube([flash_height,flash_width,holder_depth+2*bissl]);
  }
}
//collar();
 module arm() {
   
 }