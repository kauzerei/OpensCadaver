wall=2;
width=10;
depth=16;
hole=4;
nut=8;
length=80+15;
gap=2;
bissl=1/100;
difference() {
union(){
cube([length,width,depth],center=true);
translate([length/2,0,0])cube([15+2*wall,15+2*wall,depth],center=true);
translate([-length/2,0,0])cube([15+2*wall,15+2*wall,depth],center=true);
}
cube([length+15+2*wall+bissl,gap,depth+bissl],center=true);
translate([length/2,0,0])cube([15,15,depth+bissl],center=true);
translate([-length/2,0,0])cube([15,15,depth+bissl],center=true);
translate([length/2-15,0,0])rotate([90,0,0])cylinder(d=hole, h=width+bissl, center=true);
translate([-length/2+15,0,0])rotate([90,0,0])cylinder(d=hole, h=width+bissl, center=true);
translate([length/2-15,gap/2+wall,0])rotate([-90,0,0])cylinder(d=nut, h=width, $fn=6);
translate([-length/2+15,gap/2+wall,0])rotate([-90,0,0])cylinder(d=nut, h=width, $fn=6);

}