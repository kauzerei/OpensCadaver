//include <../import/BOSL2/std.scad>
/*floor=0.4;
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
*/
height=45;
width=226;
depth=128;
lip=3;
wall=0.8;
el_depth=15;
el_width=6;
/*
*intersection() {
  translate([-100,0,0])cube([200,200,200],center=true);
  union() {
    linear_extrude(height=height+lip,convexity=6) {
      difference() {
        square([width,depth],center=true);
        square([width-2*wall,depth-2*wall],center=true);
      }
    }
    translate([0,-el_depth/2-depth/2+wall,0])linear_extrude(height=height,convexity=6) {
      difference() {
        square([width+6*lip,el_depth],center=true);
        square([width+6*lip-2*wall,el_depth-2*wall],center=true);
      }
    }
    translate([0,0,height-lip])difference(){
      linear_extrude(height=lip, scale=[(width+2*lip)/width,(depth+2*lip)/depth]) square([width,depth],center=true);
      cube([width,depth,3*lip],center=true);
      translate([0,-depth/2,0])cube([width+2*lip,7*lip,3*lip],center=true);
    }
  }
}

*/

module thingy() difference() {
  union() {
    cube([width,depth,height+lip]); //bigger cube
    translate([-el_width,-el_depth+wall,0]) cube([width+el_width,el_depth,height]); //electronic cube
    translate([width/2,depth/2,height-lip]) linear_extrude(height=lip, scale=[(width+2*lip)/width,(depth+2*lip)/depth]) { //cugger lip
      square([width,depth],center=true);
    }
    translate([(width-el_width)/2,-el_depth/2+wall,height-lip]) linear_extrude(height=lip, scale=[(width+el_width+2*lip)/(width+el_width),(el_depth+2*lip)/(el_depth)]) { //lip around electronics
      square([width+el_width,el_depth],center=true);
    }
  }
  translate([wall,wall,0]) cube([width-2*wall,depth-2*wall,height+lip]); //big hole
  translate([-el_width+wall,-el_depth+2*wall,wall]) cube([width+el_width-2*wall,el_depth-2*wall,height]); //electronic hole
}

render() 
{ //divide into two parts, bring to one build plate
  translate([-100,0,0]) intersection() {
    translate([110,-50,0]) cube([200,200,200]);
    thingy();
  }
  translate([0,-25,0]) difference() {
    thingy();
    translate([110,-50,0]) cube([200,200,200]);
  }
}