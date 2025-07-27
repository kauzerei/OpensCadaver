width=1.2;
p=[[0,-67/2],[0,67/2],[17,67/2],[17,64/2],[34,64/2],[34,-64/2],[17,-64/2],[17,-67/2]];
union() {
  rotate([0,-90,0]) linear_extrude(height=width,center=true) polygon(p);
  intersection() {
    rotate([0,-90,0]) linear_extrude(height=3*width,center=true,convexity=3) difference() {
      polygon(p);
      offset(delta=-width) polygon(p);
    }
    linear_extrude(height=34,scale=[0,1]) square([16,67],center=true);
  }
}