include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;

part="keys";//[top,bottom,keys]

pcb_size=[100,70];
pcb_holes=[[3.2,3.2],[3.2,67.2],[97.2,3.2],[97.2,67.2]];
pcb_thickness=2;
pcb_slack=2;
switch=2;
screw=3;

usb_size=[10,10];
usb_pos=[18,pcb_size[1]-usb_size[1]/2];

case_wall=2;
case_top=1;
case_bottom=1;
case_rounding=2;

key_bottom=1;
key_height=2;
key_slack=1;
key_rounding=0.5;
key_chamfer=0.5;
letters=1;
hairline=2;

keys=[//zeroth row
         [[5,7],[7.4,61.5],"e"],
         [[5,7],[85.4,61.5],"d"],
         [[5,7],[92.4,61.5],"p"],
         //first row
         [[5,7],[2.4,50.5],"^"],
         [[5,7],[9.4,50.5],"1"],
         [[5,7],[16.4,50.5],"2"],
         [[5,7],[23.4,50.5],"3"],
         [[5,7],[30.4,50.5],"4"],
         [[5,7],[37.4,50.5],"5"],
         [[5,7],[44.4,50.5],"6"],
         [[5,7],[51.4,50.5],"7"],
         [[5,7],[58.4,50.5],"8"],
         [[5,7],[65.4,50.5],"9"],
         [[5,7],[72.4,50.5],"0"],
         [[5,7],[79.4,50.5],"ß"],
         [[5,7],[86.4,50.5],"´`"],
         [[5,7],[93.4,50.5],"←"],
         //second row
         [[5,7],[5.6,39.5],"⇥"],
         [[5,7],[12.6,39.5],"Q"],
         [[5,7],[19.6,39.5],"W"],
         [[5,7],[26.6,39.5],"E"],
         [[5,7],[33.6,39.5],"R"],
         [[5,7],[40.6,39.5],"T"],
         [[5,7],[47.6,39.5],"Z"],
         [[5,7],[54.6,39.5],"U"],
         [[5,7],[61.6,39.5],"I"],
         [[5,7],[68.6,39.5],"O"],
         [[5,7],[75.6,39.5],"P"],
         [[5,7],[82.6,39.5],"Ü"],
         [[5,7],[89.6,39.5],"+*"],
         [[5,7],[96.6,39.5],"↵"],
         //third row
         [[5,7],[7.4,28.5],"⇪"],
         [[5,7],[14.4,28.5],"A"],
         [[5,7],[21.4,28.5],"S"],
         [[5,7],[28.4,28.5],"D"],
         [[5,7],[35.4,28.5],"F"],
         [[5,7],[42.4,28.5],"G"],
         [[5,7],[49.4,28.5],"H"],
         [[5,7],[56.4,28.5],"J"],
         [[5,7],[63.4,28.5],"K"],
         [[5,7],[70.4,28.5],"L"],
         [[5,7],[77.4,28.5],"Ö"],
         [[5,7],[84.4,28.5],"Ä"],
         [[5,7],[91.4,28.5],"#'"],
         //fourth row
         [[5,7],[9.5,17.5],"⇧"],
         [[5,7],[16.5,17.5],"<"],
         [[5,7],[23.5,17.5],"Y"],
         [[5,7],[30.5,17.5],"X"],
         [[5,7],[37.5,17.5],"C"],
         [[5,7],[44.5,17.5],"V"],
         [[5,7],[51.5,17.5],"B"],
         [[5,7],[58.5,17.5],"N"],
         [[5,7],[65.5,17.5],"M"],
         [[5,7],[72.5,17.5],",;"],
         [[5,7],[79.5,17.5],".:"],
         [[5,7],[86.5,17.5],"-_"],
         [[5,7],[93.5,17.5],"⇧"],
         //bottom row
         [[5,7],[11.5,6.5],"c"],
         [[5,7],[18.5,6.5],"f"],
         [[5,7],[25.5,6.5],"⌘"],
         [[5,7],[32.5,6.5],"a"],
         [[43,7],[58.25,6.5]," "],
         [[5,7],[84,6.5],"a"],
         [[5,7],[91,6.5],"c"]
         ];

function key_shape(wh,cut=1)=round_corners(square(wh,center=true),cut=cut,$fn=32);

module keys2d() {
  for (key=keys) {
    translate(key[1]) polygon(key_shape(key[0],key_rounding));
  }
}

module case_top_wall_shape() difference() {
  translate([-case_wall-pcb_slack,-case_wall-pcb_slack]) polygon(round_corners(square(pcb_size+2*[case_wall,case_wall]+2*[pcb_slack,pcb_slack]),cut=case_rounding));
  translate([-pcb_slack,-pcb_slack]) polygon(round_corners(square(pcb_size+[pcb_slack,pcb_slack]),cut=pcb_slack));
}

module case_top() {
  translate([0,0,switch+pcb_thickness+key_bottom]) linear_extrude(height=case_top) difference() { //case top with key cutouts
    translate([-case_wall-pcb_slack,-case_wall-pcb_slack]) polygon(round_corners(square(pcb_size+2*[case_wall,case_wall]+2*[pcb_slack,pcb_slack]),cut=case_rounding));
    offset(delta=key_slack)keys2d();
  }
  linear_extrude(height=switch+pcb_thickness+key_bottom+bsl) case_top_wall_shape();
  translate([0,0,pcb_thickness]) linear_extrude(height=key_bottom+switch+bsl) for (tr=pcb_holes) translate(tr) {//screw stands
    difference() {
      circle(d=2*screw);
      circle(d=screw);
    }
  }
}

module keys3d() {
  difference() {
    union() {
      linear_extrude(height=key_bottom+case_top+key_height,convexity=8) keys2d();
      translate([0,0,key_bottom+case_top+key_height]) roof(method="voronoi") keys2d();
    }
    translate([0,0,key_bottom+case_top+key_height+key_chamfer]) cube([pcb_size[0],pcb_size[1],10]);
    for (key=keys) {
      translate([0,0,key_bottom+case_top+key_height-letters]) { //letters
        linear_extrude(height=letters+key_chamfer+bsl,convexity=8) { 
          translate(key[1])text(key[2],
          font=key[2]<="ü"?"Quicksand:style=Bold":"DejaVu Sans:style=Bold",
          size=3,
          valign="center",halign="center");
        }
      }
    }
  }  
}

module frame() {
  linear_extrude(height=key_bottom) {
    intersection() {
      difference() { //allowed footprint: pcb size and screw holes
        square(pcb_size);
        for (tr=pcb_holes) translate(tr) {//screw holes
          circle(d=screw);
        }
        translate(usb_pos) square(usb_size,center=true);
      }
      union() { //frame including out-of-bounds elements
        for (key=keys) { //connecting thingies
          translate(key[1]) stroke([[-50,5.55],[0,5.55],[0,0],[0,5.55],[50,5.55]],width=hairline);
        }
        //stroke(offset(square(pcb_size),delta=-hairline/2),width=hairline,closed=true); //if frame had no cutouts
        shapes=[[[hairline/2,keys[16][1][1]+6], //PikoKey-specific shape
                 [hairline/2,pcb_size[1]-hairline/2],
                 [usb_pos[0]-usb_size[0]/2-hairline/2,pcb_size[1]-hairline/2],
                 [usb_pos[0]-usb_size[0]/2-hairline/2,pcb_size[1]-hairline/2-usb_size[1]],
                 [usb_pos[0]+usb_size[0]/2+hairline/2,pcb_size[1]-hairline/2-usb_size[1]],
                 [usb_pos[0]+usb_size[0]/2+hairline/2,pcb_size[1]-hairline/2],
                 [pcb_size[0]-hairline/2,pcb_size[1]-hairline/2],
                 [pcb_size[0]-hairline/2,keys[30][1][1]+6]],
                [[pcb_size[0]-hairline/2,keys[31][1][1]+5],
                 [pcb_size[0]-hairline/2,hairline/2],
                 [hairline/2,hairline/2],
                 [hairline/2,keys[17][1][1]+5]]];
        for (shape=shapes) stroke(shape,width=hairline);
        for (tr=pcb_holes) translate(tr) {//screw hole stabilizers
          circle(d=screw+1.4*hairline);
        }
      } 
    }
  }
}

module keys() {
  frame();
  keys3d();
}

module case_bottom() {

}

if (part=="keys") keys();
if (part=="top") rotate([180,0,0]) case_top();
if (part=="bottom") case_bottom();