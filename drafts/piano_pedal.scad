include <../import/BOSL2/std.scad>
$fs=1/2;
$fa=1/2;

length=80;
width=10;
thickness=3;
joint_thickness=0.8;
joint_radius=5;
joint_angle=10;

path=path_join(paths=[[[length,-joint_radius],[0,-joint_radius]],
                      arc(32,r=joint_radius,angle=[-90,-270+joint_angle]),
                      [[0,0],length*[cos(joint_angle),sin(joint_angle)]]]);
n=len(path);
thicknesses=[thickness,thickness,for (i=[1:1:len(path)-4]) joint_thickness+(thickness-joint_thickness)*(0.5+cos(i*360/(len(path)-4))/2),thickness,thickness];

//thicknesses=[thickness,thickness,each [for (i=[1:1:n-4]) joint_thickness],thickness,thickness];
stroke(path,width=thicknesses);
//polygon(arc(32,r=joint_radius,angle=[-90,-270+joint_angle]));