include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>

$fs=1/2;
$fa=1/2;
bsl=1/100;

hex_sizes=[1.5,2,2.5,3,4,5,6,8,9,10];

slack=0.3;
wall=0.8;
hor_wall=3;
dist=0.4;
spring_width=0.5;
spring_length=10;
spring_max=0.7;
spring_min=0.5;
round_length=5;

last=len(hex_sizes)-1;
adjusted=[for (hex=hex_sizes) sqrt(4/3)*(hex+2*slack)];
widths=[for (d=adjusted) wall+2*dist+2*spring_width+d];
xs=cumsum([0, for (i=[0:1:last-1]) (widths[i]+widths[i+1])/2]); //translations
beg=-widths[0]/2;
end=xs[last]+widths[last]/2;

//magical math to find the optimal outer shape
function b(r1,r2,x1,x2)=(x1*r2-x2*r1)/(r2-r1);
function a(r1,r2,x1,x2)=r2/(x2-b(r1,r2,x1,x2));
function d(a,b,r,x)=a*(x-b)-r;
rs=[for (i=[0:1:last]) adjusted[i]/2+hor_wall];
//d are lists of extra wall thicknesses given that outer shell is supported on ith and jth hole
//we ignore all d, which have negative values, which means that for some holes the wall is extra thinner
ds=[ for(i=[0:1:last],j=[0:1:i-1]) let(b=b(rs[i],rs[j],xs[i],xs[j]),
                                      a=a(rs[i],rs[j],xs[i],xs[j]),
                                      d=[for(k=[0:1:last]) d(a,b,rs[k],xs[k])])
                                      if (min(d)>-bsl) 
                                      [a,b,sum(d)]];
//out of those that have nesessary thickness we find where it is minimal
mind=ds[min_index([for (i=[0:1:len(ds)-1]) ds[i][2]])];
a=mind[0];
b=mind[1];
//given the parameters of optimal straight line a,b we use them to calculate cylinders of final hull() 
rmin=a*(beg-b);
rmax=a*(end-b);
thickness=2*rmax;
ang=asin(a);

module unit_holder(d,spring_width,spring_shape,spring_length,round_length,dist,thickness,wall) {
  //spring_dev=(1-sqrt(3/4))*d/2+spring_compression
  difference() {
    union() { //round holders
      translate([0,round_length/2+spring_length/2,0]) cube([d+2*spring_width+2*dist,round_length,thickness],center=true);
      translate([0,-round_length/2-spring_length/2,0]) cube([d+2*spring_width+2*dist,round_length,thickness],center=true);
    } //round holes
    rotate([-90,90,0]) cylinder(d=d,h=spring_length+2*round_length+bsl,center=true); //$fn=6 for hexagonal holes
  }
  translate([-d/2-spring_width-dist-wall/4,0,0]) cube([wall/2+bsl,2*round_length+spring_length,thickness],center=true);
  translate([d/2+spring_width+dist+wall/4,0,0]) cube([wall/2+bsl,2*round_length+spring_length,thickness],center=true);
  linear_extrude(height=thickness,center=true,convexity=4) {
    spring=smooth_path([[d/2+spring_width/2,-spring_length/2],
                        [d/2+spring_width/2-spring_shape,0],
                        [d/2+spring_width/2,spring_length/2]],method="edges",uniform=false,relsize=0.05);
    stroke(spring,width=spring_width);
    stroke(-spring,width=spring_width);
  }
}

module holder() rotate([0,-ang,0]) intersection() {
  union() {
    for (i=[0:1:last]) translate([xs[i],0,0]) { //individual holders
      spring_shape=min((1-sqrt(3/4))*adjusted[i]/2+spring_max,0.5*adjusted[i]-spring_min/2);
      unit_holder(adjusted[i],spring_width,spring_shape,spring_length,round_length,dist,thickness,wall);
    }
    //extra wall behind the last
    translate([end,-spring_length/2-round_length,-thickness/2]) {
      cube([thickness,spring_length+2*round_length,thickness]);
    }
    //extra wall before the first
    translate([beg-thickness,-spring_length/2-round_length,-thickness/2]) {
      cube([thickness,spring_length+2*round_length,thickness]);
    }
  }
  hull() {
    translate([beg,0,0]) rotate([90,0,0]) cylinder(d=2*rmin,h=spring_length+2*round_length,center=true);
    translate([end,0,0]) rotate([90,0,0]) cylinder(d=2*rmax,h=spring_length+2*round_length,center=true);
  }
}
holder();
