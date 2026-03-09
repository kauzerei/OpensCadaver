$fs=1/1;
$fa=1/1;
bsl=1/100;

od=8;
id=4.5;
lip=2;
tooth=0.5;
length=8;

difference() {
  union() {
    translate([0,0,bsl])cylinder(d=od+2*lip,h=lip);
    translate([0,0,lip]) cylinder(d=od,h=length-bsl);
  }
  render() for(i=[0:tooth*2:length+lip]) translate([0,0,i]) for (m=[0,1]) mirror([0,0,m]) cylinder(d1=id,d2=id+2*tooth,h=tooth);
  translate([-10,0,-bsl])cube([20,20,20]);
}