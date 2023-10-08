/* Washer
can be useful in any project */
$fn=64;
id=11;
od=14;
h=8;
difference() {
  cylinder(d=od,h=h,center=true);
  cylinder(d=id,h=h+0.02,center=true);
}