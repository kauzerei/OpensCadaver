bissl=1/100;
$fa=1/1;
$fs=1/2;
%scale([11.2,11.2,11.2])rotate([-90,0,0])translate([1.73,-1.5,0.7])rotate([0,-7.8,-1])import("/Users/kauzerei/Downloads/e3dab823656a4c8da602c713ce2c536c/3DModel_LowPoly.stl");
hull() {
  translate([-30,7,0])bublik(3,10);
  translate([62,2,0])bublik(3,20);

  }
hull() {
translate([-15,7,0])bublik(3,10);
translate([15,7,0])bublik(3,10);
translate([0,11,0.5])bublik(3,10);
}
module bublik(h,w) {
  minkowski() {
    translate([0,0,h/2])cylinder(d=w-h,h=bissl);
    sphere(r=h/2);
  }
}