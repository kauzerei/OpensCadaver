// Adapter tube to connect vacuum cleaner to renovator, 
// which has the tube of different diameter
$fn=128;
d1=35;
d2=32.6;
h=15;
cylinder(d=d1,h=h);
translate([0,0,2*h])cylinder(d=d2,h=h);
translate([0,0,h])cylinder(d1=d1,d2=d2,h=h);