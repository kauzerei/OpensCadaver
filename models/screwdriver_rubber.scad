include <../import/BOSL2/std.scad>
$fn=64;
p=[[31/2,50],[33/2,40],[32/2,29],[22/2,15],[20/2,10],[22/2,5],[25/2,1],[25/2,0]];
sp=smooth_path(p,uniform=true,relsize=0.03);
//spb=[for (pt=reverse(sp)) pt+[2,0]];
spb=[for (pt=sp) pt+[2,0]];
fp=[each sp, each spb];
difference() {
  rotate_sweep(spb,texture="ribs",caps=true,tex_taper=0,tex_depth=1,tex_size=3);
  rotate_sweep(sp,caps=true);
  translate([0,0,36.5])rotate([90,0,0]) linear_extrude(height=50,center=true) intersection() {
    polygon(smooth_path(square([7,21],center=true),uniform=true,relsize=0.07,closed=true));
    square([10,21],center=true);
  }
}
linear_extrude(height=1.5) difference() {
  circle(d=26);
  circle(d=22);
}