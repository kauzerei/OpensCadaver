include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
p=[[31/2,0],[33/2,17],[20/2,40],[23/2,48],[24/2,51]];
sp=smooth_path(p);
spb=[for (pt=reverse(sp)) pt+[2,0]];
fp=[each sp, each spb];
//echo(spb);
//stroke(fp);
rotate_extrude(angle=360) polygon(fp);
       