include <../import/BOSL2/std.scad>
$fa=1/2;
$fs=1/2;
bsl=1/100;

part="cyberdeck";//[top,bottom,keys,cyberdeck,NOSTL_all]

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
case_bottom=2;
case_rounding=2;
case_seam=0.4;

key_bottom=1;
key_height=2;
key_slack=0.7;
key_rounding=0.7;
key_chamfer=0.7;
letters=1;
hairline=2;

keys=[//zeroth row
         [[5,7],[7,61.5],"e"],
         [[5,7],[85.4,61.5],"d"],
         [[5,7],[92.4,61.5],"p"],
         //first row
         [[5,7],[2.8,50.5],"^"],
         [[5,7],[9.8,50.5],"1"],
         [[5,7],[16.8,50.5],"2"],
         [[5,7],[23.8,50.5],"3"],
         [[5,7],[30.8,50.5],"4"],
         [[5,7],[37.8,50.5],"5"],
         [[5,7],[44.8,50.5],"6"],
         [[5,7],[51.8,50.5],"7"],
         [[5,7],[58.8,50.5],"8"],
         [[5,7],[65.8,50.5],"9"],
         [[5,7],[72.8,50.5],"0"],
         [[5,7],[79.8,50.5],"ß"],
         [[5,7],[86.8,50.5],"´`"],
         [[5,7],[93.8,50.5],"←"],
         //second row
         [[5,7],[5,39.5],"⇥"],
         [[5,7],[12,39.5],"Q"],
         [[5,7],[19,39.5],"W"],
         [[5,7],[26,39.5],"E"],
         [[5,7],[33,39.5],"R"],
         [[5,7],[40,39.5],"T"],
         [[5,7],[47,39.5],"Z"],
         [[5,7],[54,39.5],"U"],
         [[5,7],[61,39.5],"I"],
         [[5,7],[68,39.5],"O"],
         [[5,7],[75,39.5],"P"],
         [[5,7],[82,39.5],"Ü"],
         [[5,7],[89,39.5],"+*"],
         [[5,7],[96,39.5],"↵"],
         //third row
         [[5,7],[7,28.5],"⇪"],
         [[5,7],[14,28.5],"A"],
         [[5,7],[21,28.5],"S"],
         [[5,7],[28,28.5],"D"],
         [[5,7],[35,28.5],"F"],
         [[5,7],[42,28.5],"G"],
         [[5,7],[49,28.5],"H"],
         [[5,7],[56,28.5],"J"],
         [[5,7],[63,28.5],"K"],
         [[5,7],[70,28.5],"L"],
         [[5,7],[77,28.5],"Ö"],
         [[5,7],[84,28.5],"Ä"],
         [[5,7],[91,28.5],"#'"],
         //fourth row
         [[5,7],[9.1,17.5],"⇧"],
         [[5,7],[16.1,17.5],"<"],
         [[5,7],[23.1,17.5],"Y"],
         [[5,7],[30.1,17.5],"X"],
         [[5,7],[37.1,17.5],"C"],
         [[5,7],[44.1,17.5],"V"],
         [[5,7],[51.1,17.5],"B"],
         [[5,7],[58.1,17.5],"N"],
         [[5,7],[65.1,17.5],"M"],
         [[5,7],[72.1,17.5],",;"],
         [[5,7],[79.1,17.5],".:"],
         [[5,7],[86.1,17.5],"-_"],
         [[5,7],[93.1,17.5],"⇧"],
         //bottom row
         [[5,7],[11.1,6.5],"c"],
         [[5,7],[18.1,6.5],"f"],
         [[5,7],[25.1,6.5],"⌘"],
         [[5,7],[32.1,6.5],"a"],
         [[43,7],[58,6.5]," "],
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
  translate([-pcb_slack,-pcb_slack]) polygon(round_corners(square(pcb_size+2*[pcb_slack,pcb_slack]),cut=pcb_slack));
  translate(usb_pos+[0,pcb_slack+case_wall+bsl]) square(usb_size,center=true);
}

module case_top() {
  translate([0,0,switch+pcb_thickness+key_bottom]) linear_extrude(height=case_top) difference() { //case top with key cutouts
    translate([-case_wall-pcb_slack,-case_wall-pcb_slack]) polygon(round_corners(square(pcb_size+2*[case_wall,case_wall]+2*[pcb_slack,pcb_slack]),cut=case_rounding));
    offset(delta=key_slack)keys2d();
    for (tr=pcb_holes) translate(tr) circle(d=screw);
  }
  linear_extrude(height=switch+pcb_thickness+key_bottom+bsl) case_top_wall_shape();
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
                 [pcb_size[0]-hairline/2,keys[30][1][1]+6],
                 [pcb_size[0],keys[30][1][1]+6],
                 [pcb_size[0],keys[31][1][1]+5]
                 ],
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
  linear_extrude(height=case_bottom) difference() {
    offset(delta=-case_seam) translate([-pcb_slack,-pcb_slack]) {
      polygon(round_corners(square(pcb_size+2*[pcb_slack,pcb_slack]),cut=pcb_slack));
    }
    for (tr=pcb_holes) translate(tr) circle(d=screw);
  }
}
/*
module holder() {
  width=155;
  height=73;
  thickness=9;
  corner=6;
  holder_wall=2;
  chamfer=2;
  lens=3;
  
  round=corner+holder_wall;
  outer=offset(square([width,height],center=true),delta=-corner);
  translate([0,-height/2,0]) difference() {
    for (c1=outer) for (c2=outer) hull() {
      translate(c1) cyl(d=2*round, l=thickness+holder_wall, chamfer=chamfer,anchor=BOTTOM);
      translate(c2) cyl(d=2*round, l=thickness+holder_wall, chamfer=chamfer,anchor=BOTTOM);
    }
  translate([0,height/2,0]) hull() path_sweep2d(rot(-90,p=move([-9/2-holder_wall-bsl,-2],p=arc(width=9,thickness=2))),rect([width,height*2],rounding=6,anchor=TOP)); 
  translate([0,0,holder_wall+thickness/2]) cuboid([200,10,5],chamfer=1,anchor=RIGHT); 
  }
  translate([-pcb_size[0]/2,20,0]) translate([0,holder_wall+pcb_slack+case_wall,0]) case_bottom();
  translate([-40,0,0])cube([80,30,holder_wall]);
}
*/

  width=155;
  height=75;
  thickness=11.5;
  corner=6;
  holder_wall=2;
  structure=10;
  offset=20;
  chamfer=2;

module phone_cutout() {
//  side_profile=smooth_path([[0,9],[7,0],[11.5,1.5]],tangents=[[0,-1],[1,0],[1.5,1]],size=2.3);
  side_profile=smooth_path([[-9,0],[0,7],[-1.5,11.5]],tangents=[[1,0],[0,1],[-1,2]],size=2.3);
  phone_shape=rect([width,height],rounding=corner);
//  polygon(side_profile);
  hull() path_sweep2d(side_profile,phone_shape,closed=true);
}

module holding_shape() {
  phone_shape=rect([width,height],rounding=corner);
  difference() {
    offset_sweep(offset(r=holder_wall,phone_shape),height=thickness+holder_wall, bottom=os_chamfer(width=chamfer), top=os_chamfer(width=chamfer));
    translate([0,0,holder_wall+bsl]) minkowski() {
      phone_cutout();
      scale([0,-50,0]) cube([1,1,1]);
    }
    translate([0,0,holder_wall+thickness/2+1]) cuboid([200,12,6],chamfer=1,anchor=RIGHT); 
  }
}

module holder() {
  outer=offset(square([width,height],center=true),delta=holder_wall-structure/2);
  intersection() {
    holding_shape();
    for (c1=outer) for (c2=outer) hull() {
      translate(c1) cylinder(d=structure,h=thickness+holder_wall+bsl);
      translate(c2) cylinder(d=structure,h=thickness+holder_wall+bsl);
    }
  }
}

kbd=switch+pcb_thickness+key_bottom+case_top+case_bottom;
depth=(2*case_wall+2*pcb_slack+pcb_size[1]-(pcb_holes[1]-pcb_holes[0])[1])/2;

module cyberdeck() {
  structure=screw+2*holder_wall;
  translate([0,-height/2-holder_wall,0]) holder();
  translate([-(pcb_holes[2][0]+pcb_holes[0][0])/2,0,0])for (tr=[[pcb_holes[0][0],0],[pcb_holes[2][0],0]]) translate(tr) difference() {
    translate([-structure/2,-chamfer,0]) cube([structure,offset+chamfer+depth+screw/2+holder_wall,kbd+2*holder_wall]);
    translate([-structure/2-bsl,offset+chamfer,holder_wall])cube([structure+2*bsl,depth+screw/2+holder_wall,kbd]);
    translate([0,offset+depth,-bsl]) cylinder(d=screw,h=kbd+2*holder_wall+2*bsl);
  }
}

if (part=="keys") keys();
if (part=="top") rotate([180,0,0]) case_top();
if (part=="bottom") case_bottom();
if (part=="cyberdeck") cyberdeck();
if (part=="NOSTL_all") {keys(); case_top(); translate([0,0,-case_bottom]) case_bottom();}
