use <../import/publicDomainGearV1.1.scad>
$fa=1/1;
$fs=1/1;
*difference() { //porst color reflex 55/1.4
  gear(0.8*3.1415926,86,16,60);
  cylinder(d=63,h=16,center=true);
  *cylinder(h=20,d=62,center=true);
  for( a=[0:360/30:360]) rotate([0,0,a])translate([0,-2,-8]) cube([32.5,4,16]);
}
*difference() { //Tamron 28-75/2.8 Di LD
  gear(0.8*3.1415926,92,13,60);
  cylinder(h=14,d=69,center=true);
}
*difference() { //Tamron 19-35
  gear(0.8*3.1415926,92,7,60);
  cylinder(h=8,d=69,center=true);
}
*difference() { //sigma ultrawide 24/2.8
  gear(0.8*3.1415926,86,7,60);
  cylinder(h=8,d=64,center=true);
}
*difference() { //beroflex 35/2.8
  gear(0.8*3.1415926,80,11,50);
  cylinder(h=12,d=59,center=true);
}
*difference() { //noname mc 28/2.8
  gear(0.8*3.1415926,78,13,50);
  cylinder(h=14,d=59,center=true);
}
*difference() { //reflecta 55/1.7
  gear(0.8*3.1415926,82,10,50);
  cylinder(h=11,d=62,center=true);
}
*difference() { //noname 85/1.8
  gear(0.8*3.1415926,78,15,50);
  cylinder(h=16,d=59,center=true);
}
difference() { //beroflex 135/2.8
  gear(0.8*3.1415926,77,23,50);
  cylinder(h=24,d=58,center=true);
}