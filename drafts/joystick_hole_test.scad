$fa=1/1;
$fs=1/2;
dist=10;
diam=8;
height=8;
diams=[4.0, 4.3, 4.6];
widths=[3.0, 3.3, 3.6];
linear_extrude(height=height) for (x=[0:len(diams)-1]) {
  for (y=[0:len(widths)-1]) {
    translate([x*dist,y*dist]) difference() {
      circle(d=diam);
      intersection() {
        square([diams[x],widths[y]],center=true);
        circle(d=diams[x]);
      }
    }
  }
}
linear_extrude(height=0.4)difference(){
translate([-1.7*dist,-1.5*dist])square([dist*(len(diams)+1.4),dist*(len(widths)+1)]);
for (x=[0:len(diams)-1]) translate([(x-0.5)*dist,-dist])text(str(diams[x]),size=dist/2);
for (y=[0:len(widths)-1]) translate([-1.5*dist,(y-0.3)*dist])text(str(widths[y]),size=dist/2);
}
