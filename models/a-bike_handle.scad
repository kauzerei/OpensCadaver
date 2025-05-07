include <../import/BOSL2/std.scad>
include <../import/BOSL2/rounding.scad>
//zval,rear,front,width 32,34,36,33,41
params=[[0,-16,16,32],
[15,-17,16,34],
[45,-16,19,33],
[75,-17,17,34],
[105,-16,25,32]
];
fl=50;
//p0=[for (param=params) [param[0],param[1]]];
//p0s=smooth_path(p0);
//p1=[for (param=params) [param[0],param[2]]];
//p1s=smooth_path(p1);
//p2=[for (param=params) [param[0],param[3]]];
//p2s=smooth_path(p2);
//pars=[for (i=[0:len(p0s)-1]) [p0s[i][0],p0s[i][1],p1s[i][1],p2s[i][1]]];
zval=[0,15,45,85,105];
back=[-16,-17,-16,-16,-16/cos(20)];
front=[16,16,19,17,25/cos(20)];
width=[32,34,33,34,32];
angle=[0,0,0,0,-20];
backs=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],back[i]]],splinesteps=fl/2),fl,closed=false);
fronts=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],front[i]]],splinesteps=fl/2),fl,closed=false);
widths=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],width[i]]],splinesteps=fl/2),fl,closed=false);
angles=resample_path(smooth_path([for (i=[0:len(zval)-1]) [zval[i],angle[i]]],splinesteps=fl/2),fl,closed=false);
zvals=[for (i=[0:fl-1]) (backs[i][0]+fronts[i][0]+widths[i][0]+angles[i][0])/4];
echo (zvals);
echo(len(backs));
echo(len(fronts));
echo(len(widths));
echo(len(angles));
//crossections=[for (param=pars) move([(param[2]+param[1])/2,0,param[0]],path3d(ellipse(d=[param[2]-param[1],param[3]])))];
/*crossections=[for (i=[0:fl-1]) move([(fronts[i][1]-backs[i][1])/2,0,zvals[i]],
                                    p=yrot(angles[i][1],
                                    p=path3d(ellipse(d=[fronts[i][0]-backs[i][0],widths[1][0]]))))];
*/

//crossections=[for (i=[0:fl-1]) move([(fronts[i][1]+backs[i][1])/2,0,zvals[i]],path3d(ellipse(d=[fronts[i][1]-backs[i][1],widths[i][1]])))];
crossections=[for (i=[0:fl-1]) move([(fronts[i][1]+backs[i][1])/2,0,zvals[i]],
                                    yrot(angles[i][1],path3d(ellipse(d=[fronts[i][1]-backs[i][1],widths[i][1]],$fn=64)))
                                    )];
skin(crossections,slices=1);
//cap=resample_path(crossections[len(crossections)-1],6);
cap=crossections[len(crossections)-1];
rounded_prism(cap,top=up(1,cap),joint_top=0.8);