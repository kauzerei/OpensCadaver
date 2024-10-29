bissl=1/100;
part="solid";//[solid,holes]
nx=3;
stepx=5;
ny=3;
stepy=5;
nz=nx+ny-1;
stepz=4;
xs=[for (i=[stepx*nx:-stepx:stepx]) i];
ys=[for (i=[stepy*ny:-stepy:stepy]) i];
zs=[for (i=[stepz:stepz:stepz*nz]) i];
echo(zs);
if (part=="solid") {
  for (i=[0:nx-1]) {
    cube([xs[i],ys[0],zs[i]]);
  }
  for (i=[0:ny-1]) {
    echo(ys[i]);
    cube([xs[nx-1],ys[i],zs[nx-1+i]]);
  }
}
if (part=="holes") {
  difference() {
    cube([(nx+1)*stepx,(ny+1)*stepy,max(nx,ny)*stepz],center=true);
    intersection() {
      for (i=[0:nx-1]) translate([0,0,stepz*(1-i)]) cube([xs[i],ys[0],stepz+bissl],center=true);
      for (i=[0:ny-1]) translate([0,0,stepz*(1-i)]) cube([xs[0],ys[i],stepz+bissl],center=true);
    }
  }
}