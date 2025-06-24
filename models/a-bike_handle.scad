//Attempt at recreating original Sinclair A-Bike handle rubber grip

include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
part="cap";//[handle,cap]
$fn=128;
l=64;
//measurements of the handle: position of furthest point and rearest point, grip width and plane inclanation
//measured at certain z-values relative to the handle center
zval=[0,15,45,85,105];
back=[-16,-17,-16,-16,-16/cos(20)];
front=[16,16,19,17,25/cos(20)];
width=[32,34,33,34,32];
angle=[0,0,0,0,-20];

//smoothed and interpolated values
backs=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],back[i]]],splinesteps=l/2),l,closed=false);
fronts=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],front[i]]],splinesteps=l/2),l,closed=false);
widths=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],width[i]]],splinesteps=l/2),l,closed=false);
angles=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],angle[i]]],splinesteps=l/2),l,closed=false);
zvals=[for (i=[0:l-1]) (backs[i][0]+fronts[i][0]+widths[i][0]+angles[i][0])/4];

//last points of the arrays for calculating chamfered top
bl=backs[len(backs)-1][1];
fl=fronts[len(fronts)-1][1];
wl=widths[len(widths)-1][1];
al=angles[len(angles)-1][1];
zl=zvals[len(zvals)-1];

//grip shape without chamfer
crossections=[for (i=[0:l-1]) move([(fronts[i][1]+backs[i][1])/2,0,zvals[i]],
                                    yrot(angles[i][1],path3d(ellipse(d=[fronts[i][1]-backs[i][1],widths[i][1]],$fn=128))))];
shapes=[each crossections, move([(bl+fl)/2,0,zl+1],yrot(al,path3d(ellipse(d=[fl-bl-2,wl-2],$fn=128))))]; //add chamfer
endcap_egg=yrot(al,move([-1,0,0],path3d(egg(length=36,r1=13,r2=8,R=26,anchor="left",$fn=64))));

module handle() //difference()
{
  skin(shapes,slices=1);
//  cylinder(d=25,h=120,$fn=40);
  skin([up(zl+1,endcap_egg),up(zl-2,endcap_egg)],slices=1);
  rotate([0,0,180-54])translate([0,-1,0])cube([12.5+1.5,2,90]);
  rotate([0,0,-180+54])translate([0,-1,0])cube([12.5+1.5,2,90]);
}
if (part=="cap") yrot(20) {
  skin([endcap_egg,up(2,endcap_egg)],slices=1);
  difference() {
    union() {
      translate([0,0,-3]) cylinder(d=25,h=9.5,$fn=64);
      cylinder(d=21,h=25,$fn=64);
    }
    cylinder(d=17,h=26,$fn=64);
    skin([endcap_egg,down(10,endcap_egg)],slices=1);
  }
}

ir=21/2;
or=80;
n=20;
h=150;
subdivision=64;
ang=45;

//path=[for (i=[0:1:n-1]) each [[i*360/(2*n),id],[(i+0.5)*360/(2*n),id],[(i+0.5)*360/(2*n),od],[(i+1)*360/(2*n),od]]];

module vasgen(ir,or,n,h,subdivision,angle) {
path=[for (i=[0:1:n-1]) each [[ir,i*360/n],[ir,(i+0.5)*360/n],[or,(i+0.5)*360/n],[or,(i+1)*360/n],[ir,(i+1)*360/n]]];
path_smooth=subdivide_path(path=path,n=n*subdivision,closed=false);
path_skewed=skew(p=path_smooth,syx=tan(angle));
path_polar=polar_to_xy(path_skewed);
linear_extrude(height=h,twist=60*(h/or),slices=50) polygon(path_polar);
}

if (part=="handle") intersection() {
vasgen(ir=ir,or=or,n=n,h=h,subdivision=subdivision,angle=ang);
handle();
}