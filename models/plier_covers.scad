$fs=1/4;
$fa=1/4;
wall=1.2;
width=4;
angle=45;
length=7;
triangle=[[0,0],[sin(angle/2),cos(angle/2)],[-sin(angle/2),cos(angle/2)]];
rotate([-90,0,0]) difference() {
  linear_extrude(height=width+2*wall,center=true) {
    offset(delta=wall,chamfer=true)polygon(length*triangle);
  }
  linear_extrude(height=width,center=true) {
    polygon(length*2*triangle);
  }
}