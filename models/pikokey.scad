//render()translate([50,35,3]) import("/home/kauz/Downloads/3d_models/Piko Key Keyboard case - 6826547/files/Keys.stl", convexity=3);
include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;
pcb_size=[40,40];
pcb_holes=[[5,5],[5,35],[35,5],[35,35]];
buttons=[[[6,7],[10,26.1],"Q"],
         [[6,7],[17,26.1],"W"],
         [[6,7],[24,26.1],"E"],
         [[6,7],[31,26.1],"R"],
         [[6,7],[12,15],"A"],
         [[6,7],[19,15],"S"],
         [[6,7],[26,15],"D"],
         [[6,7],[33,15],"F"]];
case_wall=2;
case_top=1;
case_bottom=1;
button_bottom=1;
button_height=2;
button_slack=1;
pcb_thickness=2;
switch=2;
screw=3;
cut_key=0.5;
cut_case=2;
pcb_slack=1;
letters=1;
hairline=2;
function button_shape(wh,cut=1)=round_corners(square(wh,center=true),cut=cut,$fn=32);
module keys2d() {
  for (button=buttons) {
    translate(button[1]) polygon(button_shape(button[0],cut_key));
  }
}
module case_top_wall_shape() difference() {
  translate([-case_wall-pcb_slack,-case_wall-pcb_slack]) polygon(round_corners(square(pcb_size+2*[case_wall,case_wall]+2*[pcb_slack,pcb_slack]),cut=cut_case));
  translate([-pcb_slack,-pcb_slack]) polygon(round_corners(square(pcb_size+[pcb_slack,pcb_slack]),cut=pcb_slack));
}
module case_top() {
  translate([0,0,switch+pcb_thickness+button_bottom]) linear_extrude(height=case_top) difference() { //case top with key cutouts
    translate([-case_wall-pcb_slack,-case_wall-pcb_slack]) polygon(round_corners(square(pcb_size+2*[case_wall,case_wall]+2*[pcb_slack,pcb_slack]),cut=cut_case));
    offset(delta=button_slack)keys2d();
  }
  linear_extrude(height=switch+pcb_thickness+button_bottom+bsl) case_top_wall_shape()
  /*{ //top case side wall
        translate([-case_wall-pcb_slack,-case_wall-pcb_slack]) polygon(round_corners(square(pcb_size+2*[case_wall,case_wall]+2*[pcb_slack,pcb_slack]),cut=cut_case));
    translate([-pcb_slack,-pcb_slack]) polygon(round_corners(square(pcb_size+[pcb_slack,pcb_slack]),cut=pcb_slack));
  }*/
  translate([0,0,pcb_thickness]) for (tr=pcb_holes) translate(tr) linear_extrude(height=button_bottom+switch+bsl) difference() {//screw stands
    circle(r=2*screw);
    circle(r=screw);
  }
}
module keys() {
  for (button=buttons) {
    difference() {
      linear_extrude(height=button_bottom+case_top+button_height) { //buttons themselves
        translate(button[1]) polygon(button_shape(button[0],cut_key));
      }
      translate([0,0,button_bottom+case_top+button_height-letters]) { //letters
        linear_extrude(height=letters+bsl) { 
          translate(button[1])text(button[2],
          font="Quicksand:style=Bold",
          size=4,valign="center",halign="center");
        }
      }
    }
    linear_extrude(height=button_bottom) { //connecting thingies
      intersection() {
        translate(button[1]) stroke([[-20,5.55],[0,5.55],[0,0],[0,5.55],[20,5.55]],width=hairline);
        square(pcb_size);
      }
    }
  }
  linear_extrude(height=button_bottom) {
    stroke(offset(square(pcb_size),delta=-hairline/2),width=hairline,closed=true);
  }
}
//keys();
rotate([180,0,0])case_top();