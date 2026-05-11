include <../import/BOSL2/std.scad>
include <../import/BOSL2/walls.scad>
module sloptest(slop) {
  linear_extrude(5) difference() {
    projection() partition_mask(l=45,w=20,cutsize=20,cutpath="jigsaw",$slop=slop,$fn=32);
    difference() {
      offset(r=-4) projection() partition_mask(l=45,w=20,cutsize=20,cutpath="jigsaw",$slop=slop,$fn=32);
      projection() hex_panel([200,200,1],4,24,frame=0);
    }
  }
  translate([0,-20]) linear_extrude(5) difference() {
    projection() partition_mask(l=45,w=20,cutsize=20,cutpath="jigsaw",$slop=slop,$fn=32,inverse=true);
    difference() {
      offset(r=-4) projection() partition_mask(l=45,w=20,cutsize=20,cutpath="jigsaw",$slop=slop,$fn=32,inverse=true);
      projection() hex_panel([200,200,1],4,24,frame=0);

    }
  }
  linear_extrude(1) {
    translate([0,19])text(str(slop),halign="center",valign="bottom",size=10);
    translate([0,-38])text(str(slop),halign="center",valign="top",size=10);
  }
}

translate([-50,0]) sloptest(0.15);
translate([0,0]) sloptest(0.2);
//translate([50,0]) sloptest(0.1);

//partition_mask(l=800,w=500,gap=ydist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$slop=slop,$fn=16,inverse=true);