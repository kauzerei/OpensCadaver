// Mount for electric spray paint gun from Kaufland
// Used to connect film dryer to this gun as source of airflow
$fn=256;
difference() {
  union() {
    linear_extrude(2)offset(delta=-0.5) {
      circle(d=42.5);
      polygon([[0,14.9],[18.5,14.9],[20.5,12.8],[20.5,5],[21.5,5],[21.5,-5],[20.5,-5],[20.5,-12.8],[18.5,-14.9],[0,-14.9]]);
      intersection() {
        circle(d=46.5);
        translate([-7.5,-25])square([10,50]);
      }
    }
    translate([0,0,2])cylinder(d=40,h=43.5);
    translate([0,0,45.5])cylinder(d=42,h=6.7);
    translate([0,0,45.5+6.7])cylinder(d=38,h=3);
    translate([0,0,45.5+6.7+3])cylinder(d=42,h=8);
    translate([0,0,22])intersection() {
      cylinder(d=46.5,h=17);
      difference(){
        translate([-7.5,-47/2,0])cube([10,47,17]);
        translate([-2.5,-47/2,3.5])cube([10,47,10]);
      }
    }
  }
  translate([0,0,-0.1])cylinder(d=35,h=63.2+0.2);
}
