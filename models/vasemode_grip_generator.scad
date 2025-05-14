id=20;
od=80;
n=10;
h=100;
subdivision=100;
angle=45;
include <../import/BOSL2/std.scad>
//path=[for (i=[0:1:n-1]) each [[i*360/(2*n),id],[(i+0.5)*360/(2*n),id],[(i+0.5)*360/(2*n),od],[(i+1)*360/(2*n),od]]];

module vasgen(id,od,n,h,subdivision,angle) {
path=[for (i=[0:1:n-1]) each [[id,i*360/n],[id,(i+0.5)*360/n],[od,(i+0.5)*360/n],[od,(i+1)*360/n],[id,(i+1)*360/n]]];
path_smooth=subdivide_path(path=path,n=n*subdivision,closed=false);
path_skewed=skew(p=path_smooth,syx=tan(angle));
path_polar=polar_to_xy(path_skewed);
linear_extrude(height=h,twist=60*(h/od),slices=50) polygon(path_polar);
}
intersection() {
vasgen(id=id,od=od,n=n,h=h,subdivision=subdivision,angle=angle);
}