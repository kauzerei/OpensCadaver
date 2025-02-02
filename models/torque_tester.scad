$fa=1/1;
$fs=1/1;
bissl=1/100;
d=13;
l_tube=40;
square=10;
l_square=11;
wall=4;

difference(){
  hull(){
    translate([-square/2-wall,0,0])cube([square+2*wall,l_square,square+2*wall]);
    translate([0,-d/2-wall,0])cylinder(d=d+2*wall,h=l_tube);
  }
    translate([-square/2,0,wall])cube([square,l_square+bissl,square]);
    translate([0,-d/2-wall,-bissl])cylinder(d=d,h=l_tube+2*bissl);
}