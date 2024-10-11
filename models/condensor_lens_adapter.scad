$fn=256;
r=76; //curvature
th=21.6; //lens thickness
sq=76; //lens side
h=13;//original box height
w=79; //original box width
wall=3;
difference(){
  translate([-w/2,-w/2,0])cube([w,w,h]);
  translate([-w/2+wall,-w/2+wall,-1/100])cube([w-2*wall,w-2*wall,h+1/50]);
  translate([0,0,h+1/100])mirror([0,0,-1])intersection() {
    translate([0,0,-r+th]) sphere(r=r);
    translate([-sq/2,-sq/2,0]) cube([sq,sq,th]);
  }
}