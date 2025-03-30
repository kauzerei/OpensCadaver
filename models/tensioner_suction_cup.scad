$fs=1/2;
$fa=1/2;
inner=7;
outer=13;
thickness=2;
length=8;
wall=(outer-inner)/2;
linear_extrude(thickness) {
  difference() {
    circle(d=outer);
    circle(d=inner);
    translate([0,outer/2])square([outer,outer],center=true);
  }
  translate([inner/2,0])square([wall,length]);
  translate([-outer/2,0])square([wall,length]);
}