include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fa=1/2;
$fs=1/2;
bsl=1/100;

//triangular_base:
t_size=50;
t_a=70;
//magnet dimensions
m_d=12.5;
m_h=4;
m_wall=1;
//mounting ball
ball=17;
//the curvy connecting thing
offset_base=-8;
offset_ball=10;
offset_hor=55;
d_start=17;
d_end=7;

//general
wall=2;
round=2;

offset=sqrt((ball/2)^2-(d_end/2)^2);
echo(offset);

tr=zrot(180,circle(d=t_size,$fn=3));

curve=smooth_path([[offset_base,0,m_h+round+m_wall],[offset_ball,0,offset_hor]-offset*yrot(t_a,[0,0,1])],method="edges",relsize=0.2,tangents=[[0,0,1],yrot(t_a,[0,0,1])],splinesteps=40);
//diameters=[for (point=smooth_path([[d_start/100,0],[d_end/100,100]],tangents=[[0,1],[0,1]],method="edges",splinesteps=20)) point[0]];
//echo(len(curve));
//echo(len(diameters));
path_sweep(circle(d=d_start),caps=[-round,true],curve,scale=d_end/d_start);
translate([offset_ball,0,offset_hor])sphere(d=ball);


difference() {
  offset_sweep(offset(tr,r=m_d/2+wall),height=m_h+m_wall,top=os_circle(r=round));
  for (pt=tr) translate([0,0,m_wall]) translate(pt) cylinder(d=m_d,h=m_h+round);
}

/*
*yrot(-t_a) {
  difference() {
    offset_sweep(offset(tr,r=m_d/2+wall),height=m_h+m_wall,top=os_circle(r=round));
    for (pt=tr) translate([0,0,m_wall]) translate(pt) cylinder(d=m_d,h=m_h+round);
  }
}

base=yrot(-t_a,path3d(offset(tr,r=m_d/2+wall)));
shifted=left((m_h+m_wall)/sin(t_a),base);
fillet=left(round,scale(0.9,shifted));

skin([base,shifted,fillet],slices=1);

path=smooth_path([yrot(-t_a,[0,0,m_h]),[-15,0,30]],method="edges",tangents=[yrot(-t_a,[0,0,1]),[0,0,1]]);
path_sweep(circle(d=t_size/2),path,scale=0.2);
*/