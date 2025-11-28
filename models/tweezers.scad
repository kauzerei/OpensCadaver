include <../import/BOSL2/std.scad>
$fn=64;
thickness=3.2;
thinness=1.6;
length=180;
angle=30;
width=8;
arc_width=10;
arc_thickness=16;
joint=3;
teeth_width=3.2;
teeth_length=1.6;
/*p1=[[length,0],[0,0],[length*cos(angle),length*sin(angle)]];
p2=round_corners(p1,method="chamfer",width=distance,closed=false);
p3=smooth_path(p2);
stroke(p3);*/
p1=arc(width=arc_width,thickness=arc_thickness);
p2=[length*[sin(angle/2),cos(angle/2)],[0,0]];
p3=[length*[sin(angle/2),-cos(angle/2)],[0,0]];
p=simplify_path(path_join(paths=[p3,p1,p2],joint=3),maxerr=0.0001);
//echo (len(p));
thicknesses=[thinness,for (i=[1:1:len(p)-2]) thinness+(thickness-thinness)*(0.5+cos(i*360/(len(p)-2))/2),thinness];
//echo(len(thicknesses));
//teeth=5*[[0,0],[0,1],[-0.5,0],[-1,1],[-1,0]];
teeth=move(v=[-teeth_width,thinness/2],p=scale([teeth_width,teeth_length],[[0,0],[0,1],[0.5,0],[1,1],[1,0]])) ;
//tangents=path_tangents(p,closed=false);
//translate(p[0])rot()polygon(end);
linear_extrude(height=width) {
  path_copies(p,n=2,closed=false,sp=teeth_width) polygon(teeth);
  stroke(p,width=thicknesses,endcaps="butt");
}