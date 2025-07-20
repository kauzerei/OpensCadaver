include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
$fn=64;
p=[[31/2,50],[33/2,40],[32/2,29],[22/2,15],[20/2,10],[22/2,5],[26/2,0]];
sp=smooth_path(p,uniform=true,relsize=0.03);
spb=[for (pt=reverse(sp)) pt+[2,0]];
fp=[each sp, each spb];
//echo(spb);
//translate([0,0,1])color("red") stroke(p,joints="dot",width=1);
//color("blue")stroke(fp);
//color("blue")polygon(fp);
difference() {
  rotate_extrude(angle=360) polygon(fp);
  translate([0,0,36.5])rotate([90,0,0]) linear_extrude(height=50,center=true) polygon(smooth_path(square([7,21],center=true),uniform=true,relsize=0.08,closed=true));
  }
*linear_extrude(height=1.5) difference() {
  circle(d=32);
  circle(d=29);
}
linear_extrude(height=1.5) difference() {
  circle(d=26);
  circle(d=22);
}