include <../import/BOSL2/std.scad>
module sloptest(slop) {
  linear_extrude(5) difference() {
    projection() partition_mask(l=60,w=30,cutsize=20,cutpath="jigsaw",$slop=slop,$fn=16);
    offset(r=-4) projection() partition_mask(l=60,w=30,cutsize=20,cutpath="jigsaw",$slop=0.4,$fn=32);
  }
  translate([0,-20]) linear_extrude(5) difference() {
    projection() partition_mask(l=60,w=30,cutsize=20,cutpath="jigsaw",$slop=slop,$fn=16,inverse=true);
    offset(r=-4) projection() partition_mask(l=60,w=30,cutsize=20,cutpath="jigsaw",$slop=0.4,$fn=32,inverse=true);
  }
  linear_extrude(1) {
    translate([0,29])text(str(slop),halign="center",valign="bottom",size=20);
    translate([0,-48])text(str(slop),halign="center",valign="top",size=20);
  }
}

translate([-70,0]) sloptest(0);
translate([0,0]) sloptest(0.2);
translate([70,0]) sloptest(0.4);

//partition_mask(l=800,w=500,gap=ydist/2-2*puzzle,cutsize=puzzle,cutpath="jigsaw",$slop=slop,$fn=16,inverse=true);