pi=3.1415926/1;
$fa=1/1;
$fs=1/2;

nozzle=0.4;
rod=5.5;
tolerance=0.3;
shell=10;
compression=0.2;
n=8;
skew=45;
tube_length=60;
spring_length=10;

part="spring"; //[spring, tube]

module spring() {
  ri=rod/2+nozzle+tolerance-compression+nozzle;
  ro=shell/2+compression;
  s=ri*pi/n+2*nozzle; //arc length, compensated for extrusion width
  ai=360/n-360*s/(2*ri*pi);
  ao=360*s/(2*ro*pi);
  
  function pol(r,a)=[r*sin(a),r*cos(a)];

  // generating smoothed cartesian paths between following points in polar coordinates
  // (ri,0) -> (ri,ai) -> (ro,skew+ai) -> (ro,skew+ao+ai) -> (ri,360/n)
  shape=[
    for (j=[0:360/n:360-360/n]) each [
      for (i=[0:0.1:0.9]) pol(ri,j+ai*i),
      for (i=[0:0.1:0.9]) pol(ri+i*(ro-ri),j+ai+i*skew),
      for (i=[0:0.1:0.9]) pol(ro,j+skew+ai+i*ao),
      for (i=[0:0.1:0.9]) pol(ro+i*(ri-ro),j+skew+ao+ai+i*(360/n-skew-ao-ai))
    ]
  ];
  linear_extrude(height=spring_length)polygon(points=shape);
}

module tube() {
  cylinder(d=rod+2*nozzle+2*tolerance,h=tube_length);
}

if (part=="spring") spring();
if (part=="tube") tube();