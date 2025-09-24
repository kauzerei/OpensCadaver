//render()translate([50,35,3]) import("/home/kauz/Downloads/3d_models/Piko Key Keyboard case - 6826547/files/Keys.stl", convexity=3);
include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;
pcb_size=[100,70];
pcb_holes=[[3.2,3.2],[3.2,67.2],[97.2,3.2],[97.2,67.2]];
buttons=[//zeroth row
         [[6,7],[5.4,61.5],"es"],
         [[6,7],[85.4,61.5],"dl"],
         [[6,7],[92.4,61.5],"pr"],
         //first row
         [[6,7],[2.4,50.5],"^"],
         [[6,7],[9.4,50.5],"1"],
         [[6,7],[16.4,50.5],"2"],
         [[6,7],[23.4,50.5],"3"],
         [[6,7],[30.4,50.5],"4"],
         [[6,7],[37.4,50.5],"5"],
         [[6,7],[44.4,50.5],"6"],
         [[6,7],[51.4,50.5],"7"],
         [[6,7],[58.4,50.5],"8"],
         [[6,7],[65.4,50.5],"9"],
         [[6,7],[72.4,50.5],"0"],
         [[6,7],[79.4,50.5],"ß"],
         [[6,7],[86.4,50.5],"´`"],
         [[6,7],[93.4,50.5],"bs"],
         //second row
         [[6,7],[5.6,39.5],"tb"],
         [[6,7],[12.6,39.5],"Q"],
         [[6,7],[19.6,39.5],"W"],
         [[6,7],[26.6,39.5],"E"],
         [[6,7],[33.6,39.5],"R"],
         [[6,7],[40.6,39.5],"T"],
         [[6,7],[47.6,39.5],"Z"],
         [[6,7],[54.6,39.5],"U"],
         [[6,7],[61.6,39.5],"I"],
         [[6,7],[68.6,39.5],"O"],
         [[6,7],[75.6,39.5],"P"],
         [[6,7],[82.6,39.5],"Ü"],
         [[6,7],[89.6,39.5],"+*"],
         [[6,7],[96.6,39.5],"en"],
         //third row
         [[6,7],[7.4,28.5],"cs"],
         [[6,7],[14.4,28.5],"A"],
         [[6,7],[21.4,28.5],"S"],
         [[6,7],[28.4,28.5],"D"],
         [[6,7],[35.4,28.5],"F"],
         [[6,7],[42.4,28.5],"G"],
         [[6,7],[49.4,28.5],"H"],
         [[6,7],[56.4,28.5],"J"],
         [[6,7],[63.4,28.5],"K"],
         [[6,7],[70.4,28.5],"L"],
         [[6,7],[77.4,28.5],"Ö"],
         [[6,7],[84.4,28.5],"Ä"],
         [[6,7],[91.4,28.5],"#'"],
         //fourth row
         [[6,7],[9.5,17.5],"sh"],
         [[6,7],[16.5,17.5],"<"],
         [[6,7],[23.5,17.5],"Y"],
         [[6,7],[30.5,17.5],"X"],
         [[6,7],[37.5,17.5],"C"],
         [[6,7],[44.5,17.5],"V"],
         [[6,7],[51.5,17.5],"B"],
         [[6,7],[58.5,17.5],"N"],
         [[6,7],[65.5,17.5],"M"],
         [[6,7],[72.5,17.5],",;"],
         [[6,7],[79.5,17.5],".:"],
         [[6,7],[86.5,17.5],"-_"],
         [[6,7],[93.5,17.5],"sh"],
         //bottom row
//         ECHO: [32.5, 25.5, 18.5, 11.5, 4.5]
         [[6,7],[11.5,6.5],"ct"],
         [[6,7],[18.5,6.5],"fn"],
         [[6,7],[25.5,6.5],"sp"],
         [[6,7],[32.5,6.5],"al"],
         [[43.5,7],[58.25,6.5]," "],
         [[6,7],[84,6.5],"ag"],
         [[6,7],[91,6.5],"ct"],

         ];

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
pcb_slack=2;
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
    linear_extrude(height=button_bottom) {
      intersection() { //connecting thingies
        translate(button[1]) stroke([[-50,5.55],[0,5.55],[0,0],[0,5.55],[50,5.55]],width=hairline);
        difference() {
          square(pcb_size);
          for (tr=pcb_holes) translate(tr) {//screw holes
            circle(d=screw);
          }
        }
      }
    }
  }
  linear_extrude(height=button_bottom) { //frame around
    difference() {
      intersection() {
        union() {
          stroke(offset(square(pcb_size),delta=-hairline/2),width=hairline,closed=true);
          for (tr=pcb_holes) translate(tr) {//screw hole stabilizers
            circle(d=screw+1.4*hairline);
          }
        }
        difference() {
          square(pcb_size);
          for (tr=pcb_holes) translate(tr) {//screw holes
            circle(d=screw);
          }
        }
      }
      for (tr=[[2.4,50.5],[96.6,39.5]]) translate(tr) square([8,9],center=true); //special button cutouts
    }
  }
}
keys();
//case_top();
//rotate([180,0,0])case_top();