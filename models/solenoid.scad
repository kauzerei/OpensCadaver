pi=3.1415926/1;
nozzle=0.4;
rod=6;
tolerance=1;
shell=20;
compression=1;
n=10;
part="tube"; //[spring, tube]
module spring() {
ri=rod/2+nozzle+tolerance-compression+nozzle;
ro=shell/2+compression;
s=ri*pi/n+2*nozzle;
ai=360/n-360*s/(2*ri*pi);
ao=360*s/(2*ro*pi);
echo(s);
skew=36;
function pol(r,a)=[r*sin(a),r*cos(a)];
shape=[
  for (j=[0:360/n:360-360/n]) each [
    for (i=[0:0.1:0.9]) pol(ri,j+ai*i),
    for (i=[0:0.1:0.9]) pol(ri+i*(ro-ri),j+ai+i*skew),
    for (i=[0:0.1:0.9]) pol(ro,j+skew+ai+i*ao),
    for (i=[0:0.1:0.9]) pol(ro+i*(ri-ro),j+skew+ao+ai+i*(360/n-skew-ao-ai))
  ]
];

// (ri,0) -> (ri,ai) -> (ro,skew+ai) -> (ro,skew+ao+ai) -> (ri,360/n)
linear_extrude(height=10)polygon(points=shape);
}
spring();