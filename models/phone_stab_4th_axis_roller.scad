//Replacement part for chinese 4th axis stab
$fn=64;
od1=9.5;
od2=10.5;
id=4;
wid=15;
difference() {
  union() {
    cylinder(d1=od1,d2=od2,h=wid/2);
    mirror([0,0,1])cylinder(d1=od1,d2=od2,h=wid/2);
  }
  cylinder(d=id,h=wid,center=true);
}