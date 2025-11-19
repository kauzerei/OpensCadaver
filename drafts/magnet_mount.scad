$fn=32;
difference() {
  union() {
  cylinder(d=6,h=10);
  cylinder(d=10,h=8);
  }
  cylinder(d=4,h=10);
  cylinder(d1=8,d2=4,h=2);
}