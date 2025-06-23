//Replacment for lost rod, that holds thread on AEG-11230 sewing machine
$fs=1/2;
$fa=1/2;
linear_extrude(height=4.5) {
  square([6,10]);
  square([2,17]);
  //translate([0,15]) circle(r=2.5);
  polygon([[0,17],[-1,15],[0,13]]);
  translate([-5,-5]) square([3+5+5,5]);
  translate([-60-5,0]) square([60,4.5]);
  translate([-5-4.5,-10])square([4.5,24.5]);
}