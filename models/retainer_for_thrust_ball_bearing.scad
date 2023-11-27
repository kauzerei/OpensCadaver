/* Thrust ball bearing retainer
Project: Bosch drill repair */
$fn=128;
id=30.4;
od=35;
ball=1.5;
h=1.1;
n=28;
difference() {
  cylinder(d=od,h=h,center=true);
  cylinder(d=id,h=h+0.02,center=true);
  for (a=[0:360.0/n:360]) {
    rotate([0,0,a]) translate([(od+id)/4,0,0])cylinder(h=h+0.02,d=ball,center=true);
  }
}