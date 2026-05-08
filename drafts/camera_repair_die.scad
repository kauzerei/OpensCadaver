$fs=1/4;
$fa=1/4;

part="both";//[anvil,die,both]

anvil_height=10;
anvil_length=20;
anvil_width=10;
anvil_radius=0.5;

die_height=5;
die_width=10;
die_thickness=5;
die_radius=0.3;

module anvil() linear_extrude(anvil_length) {
  offset(r=anvil_radius) offset(r=-2*anvil_radius) offset(r=anvil_radius) difference() {
    square ([anvil_height,anvil_width],center=true);
    rotate(-45) square(anvil_height); 
  }
}

module die() linear_extrude(die_width) offset(r=die_radius) offset(r=-die_radius) {
  rotate(45) square(die_thickness/sqrt(2),center=true);
  translate([0,-die_thickness/2]) square([die_height,die_thickness]);
}

if (part=="anvil") anvil();
if (part=="die") die();
 if (part=="both") {anvil(); translate([4,0]) die();}