module funnel() {
  translate([0,0,20]) cylinder(d1=5,d2=40,h=20);
  cylinder(d=5,h=20);
}
/*difference() 
{
*translate([0,5,15]) cube([40,50,70],center=true);
scale(24/16) rotate([-160,0,0]) translate([-45,0,-7]) import("../import/skull_ring_girl_16mm.stl");
translate([12.5,-5,5])cylinder(d=4,h=51);
translate([-12.5,-5,5])cylinder(d=4,h=51);
translate([0,14,13]) funnel(); 
}*/
scale(24/16) rotate([-0,0,0]) translate([-45,0,-7]) import("../import/skull_ring_girl_16mm.stl");
