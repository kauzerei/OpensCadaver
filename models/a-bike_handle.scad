include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
l=64;
zval=[0,15,45,85,105];
back=[-16,-17,-16,-16,-16/cos(20)];
front=[16,16,19,17,25/cos(20)];
width=[32,34,33,34,32];
angle=[0,0,0,0,-20];

backs=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],back[i]]],splinesteps=l/2),l,closed=false);
fronts=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],front[i]]],splinesteps=l/2),l,closed=false);
widths=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],width[i]]],splinesteps=l/2),l,closed=false);
angles=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],angle[i]]],splinesteps=l/2),l,closed=false);
zvals=[for (i=[0:l-1]) (backs[i][0]+fronts[i][0]+widths[i][0]+angles[i][0])/4];

bl=backs[len(backs)-1][1];
fl=fronts[len(fronts)-1][1];
wl=widths[len(widths)-1][1];
al=angles[len(angles)-1][1];
zl=zvals[len(zvals)-1];
echo(zl);
crossections=[for (i=[0:l-1]) move([(fronts[i][1]+backs[i][1])/2,0,zvals[i]],
                                    yrot(angles[i][1],path3d(ellipse(d=[fronts[i][1]-backs[i][1],widths[i][1]],$fn=128)))
                                    )];
shapes=[each crossections, move([(bl+fl)/2,0,zl+1],yrot(al,path3d(ellipse(d=[fl-bl-2,wl-2],$fn=128))))]; //add chamfer
endcap_egg=up(zl-2,yrot(al,move([-1,0,0],path3d(egg(length=36,r1=13,r2=8,R=26,$fn=64,anchor="left")))));
difference() {
  skin(shapes,slices=1);
  cylinder(d=25,h=120,$fn=40);
  skin([up(3,endcap_egg),endcap_egg],slices=1);
  rotate([0,0,180-54])translate([0,-1,0])cube([12.5+1.5,2,90]);
  rotate([0,0,-180+54])translate([0,-1,0])cube([12.5+1.5,2,90]);
}