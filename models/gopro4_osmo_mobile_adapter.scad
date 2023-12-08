//Stable and fast to print gopro-style camera holder for a phone gimbal
//The camera protrudes forward, so the gimbal itself is not in the frame
//Designed for GoPro 4 Silver and Osmo Mobile, but can be customized for your dimensions
part="visualisation"; //[holder,bracket,visualisation]
//how far to the front the camera protrudes
offset=48;
//width of gimbal jaws
width=50;
//gimbal jaws opening
height=70;
//thickness of the parts
wall=2.4;
//dimensions of the camera
camera=[60,22,42];
//size of the latch for clipping the camera
latch=2.4;
//width of space between the lens and front screen
bracket_width=8;
module holder(offset=48,width=50,height=70,wall=2.4,camera=[60,22,42]) {
  translate([wall,0,0])cube([width,wall,height]);
  cube([wall,offset,height]);
  difference() {
    translate([-camera[0]-wall,offset-camera[1]-wall*2,0])cube([camera[0]+2*wall,camera[1]+2*wall,wall*2]);
    translate([-camera[0],offset-camera[1]-wall,wall])cube(camera);
  }
}
module bracket(wall=2.4,camera=[60,22,42],latch=2.4,bracket_width=4) {
  linear_extrude(height=bracket_width) {
  square([wall,2*wall]);
  translate([camera[1]+3*wall,0])square([wall,4*wall]);
  translate([camera[1]+2*wall,3*wall])square([wall,camera[2]]);
  translate([wall,0,])square([camera[1]+2*wall,wall]);
  translate([2*wall,camera[2]+2*wall])square([camera[1],wall]);
  translate([2*wall,camera[2]+3*wall])polygon([[0,0],[-latch-wall,0],[0,-latch-wall]]);
    }
}
if (part=="holder") holder(offset=offset,width=width,height=height,wall=wall,camera=camera);
if (part=="bracket") bracket(wall=wall,camera=camera,latch=latch,bracket_width=bracket_width);
if (part=="visualisation") {
color([0.5,0.5,1])holder(offset=offset,width=width,height=height,wall=wall,camera=camera);
color([0.5,1,0.5])translate([-camera[0]/2-bracket_width/2,offset-camera[1]-3*wall,-wall])rotate([90,0,90])bracket(wall=wall,camera=camera,latch=latch,bracket_width=bracket_width);
color([1,0.5,0.5])translate([-camera[0],offset-camera[1]-wall,wall])cube(camera);
}