include <../import/BOSL2/std.scad>
include <../import/BOSL2/walls.scad>
$fs=1/2;
$fa=1/2;
bsl=1/100;
xseams=[-220,-60,150];
yseams=[170,20,-130,-280];
xdist=abs(xseams[1]-xseams[0]);
ydist=abs(yseams[1]-yseams[0]);
xshift=-25;
yshift=-10;
puzzle=20;
wall=4;
height=5;
cell=30;
slop=0.15;
part="np0";//[00,01,02,03,10,11,12,13,20,21,22,23,np0,np1]

module neck_pocket(width1,width2,length,radius,rounding) {
  height=radius-sqrt(radius^2-(width1^2)/4);
  arc=arc(points=[[height,width1/2],[0,0],[height,-width1/2]]);
  path=[[height,-width1/2],[length,-width2/2],[length,width2/2],[height,width1/2]];
  polygon(path_join([arc,path],[rounding,rounding],closed=true));
}

//bass: 
module bass_cutout() {
  neck_pocket(64,60.4,100,250,9.5);
  translate([-108,18]) rect([28.5,57.5]);
  translate([-136,-18]) rect([28.5,57.5]);
  translate([-260,0]) rect([1,70]);
}

//guitar: 
module guitar_cutout() {
  neck_pocket(57.5,54.9,78,300,9.5);
  *translate([-24,0]) rect([17,70],rounding=8);
  *translate([-82,0]) rect([17,70],rounding=8);
  translate([-140,0]) rotate(-10) rect([17,70],rounding=8);
  translate([-183,0]) rect([1,70]);
}

*difference() {
  translate([-261.4,-381])import("../import/guitar_contour.svg");
  translate([0,175/2]) guitar_cutout();
  translate([0,-175/2]) bass_cutout();
}

//intersection() {
  //translate([-261.4,-381])import("../import/guitar_contour.svg");
  //partition_mask(w=300,l=800,gap=10, cutpath="jigsaw");
//}

//partition(size=[800,800,1],spread=12,gap=50,cutpath="jigsaw",$fn=32) translate([-261.4,-381])import("../import/guitar_contour.svg");

*difference() {
  translate([-261.4,-381])import("../import/guitar_contour.svg");
  *for (x=xseams) translate([x,yshift]) rotate(90) {
    partition_cut_mask(l=800,gap=ydist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$slop=slop,$fn=8);
  }
  *for (y=yseams) translate([xshift,y]) {
    partition_cut_mask(l=800,gap=xdist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$slop=slop,$fn=8);
  }
  translate([0,175/2]) guitar_cutout();
  translate([0,-175/2]) bass_cutout();
}

module piece(i,j) intersection() {
  translate([-261.4,-381])import("../import/guitar_contour.svg");
  intersection() {
    translate([xseams[i],yshift]) rotate(90) {
      projection() partition_mask(l=800,w=500,gap=ydist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$slop=slop,$fn=32);
    }
    if(i>0) translate([xseams[i-1],yshift]) rotate(90) {
      projection() partition_mask(l=800,w=500,gap=ydist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$slop=slop,$fn=32,inverse=true);
    }
  }
  intersection() {
    translate([xshift,yseams[j]]) {
      projection() partition_mask(l=800,w=500,gap=xdist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$fn=32,$slop=slop);
    }
    if(j>0) translate([xshift,yseams[j-1]]) {
      projection() partition_mask(l=800,w=500,gap=xdist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$fn=32,$slop=slop,inverse=true);
    }
  }
}

module skeletonize() {
  difference() {
    children();
    difference() {
      offset(r=-wall) children();
      projection() hex_panel([800,800,1],wall,cell,frame=0);
    }
  }
}

module np_jig(negative) {
  intersection() {
    difference() {
      translate([-261.4,-381])import("../import/guitar_contour.svg");
      translate([0,175/2]) guitar_cutout();
      translate([0,-175/2]) bass_cutout();
    }
  projection() partition_mask(l=150,w=150,gap=0,cutsize=15,cutpath="jigsaw",$fn=32,$slop=slop,inverse=negative);
  }
}

linear_extrude(height) skeletonize() {
if (part=="00") piece(0,0);
if (part=="01") piece(0,1);
if (part=="02") piece(0,2);
if (part=="03") piece(0,3);
if (part=="10") piece(1,0);
if (part=="11") piece(1,1);
if (part=="12") piece(1,2);
if (part=="13") piece(1,3);
if (part=="20") piece(2,0);
if (part=="21") piece(2,1);
if (part=="22") piece(2,2);
if (part=="23") piece(2,3);
if (part=="np0") np_jig(false);
if (part=="np1") np_jig(true);
}

*linear_extrude(height,convexity=10) {
skeletonize() piece(0,0);
skeletonize() piece(0,1);
skeletonize() piece(0,2);
skeletonize() piece(0,3);
skeletonize() piece(1,0);
skeletonize() piece(1,1);
skeletonize() piece(1,2);
skeletonize() piece(1,3);
skeletonize() piece(2,0);
skeletonize() piece(2,1);
skeletonize() piece(2,2);
skeletonize() piece(2,3);
}