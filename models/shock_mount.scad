$fa=1/1;
$fs=1/2;
bissl=1/100;

mic_id=60;
inner_length=30;
wall=3;
n_beams=5;
inner_beams=60;
outer_id=90;
outer_beams=60;
outer_length=30;
cable_d=3;
wiggle_room=0.4;
bend=30;

module hook(a=120) {
difference(){
circle(d=2*wall+cable_d);
circle(d=cable_d);
polygon (points=[[0,0],for(i=[0:a])[(wall+cable_d)*sin(i),(wall+cable_d)*cos(i)]],paths=[[for(i=[0:a]) i]]);
}
translate([(cable_d/2+wall/2)*sin(a),(cable_d/2+wall/2)*cos(a)])circle(d=wall);
translate([0,cable_d/2+wall/2])circle(d=wall);
translate([-wall/2,(cable_d/2+wall/2)*cos(0)])square([wall,wall/2]);

}

module bent_hook(l=50,stoppers=30) {
rotate(-bend){
translate([-wall/2,0])square([wall,(l-stoppers)/2]);
translate([0,cable_d/2+wall+(l-stoppers)/2])mirror([0,1])hook();
polygon(points=[[-wall/2,0],[-wall/2-wall*cos(bend),-wall*sin(bend)],[-wall/2,wall]], paths=[[0,1,2]]);
}
}
module beam(l=50,stoppers=30) {
linear_extrude(height=wall,center=true){
//translate([0,-cable_d/2-wall-l/2])hook();
//polygon(points=[[-wall/2,-stoppers/2],[-1.5*wall,-stoppers/2],[-wall/2,-stoppers/2-wall]], paths=[[0,1,2]]);
//square([wall,l],center=true);
translate([0,stoppers/2])bent_hook(l=l,stoppers=stoppers);
mirror([0,1])translate([0,stoppers/2])bent_hook(l=l,stoppers=stoppers);
hull() {
translate([0,stoppers/2])circle(d=wall);
translate([0,-stoppers/2])circle(d=wall);
}
}
}

module inner_shell(n=n_beams) {
linear_extrude(inner_length,center=true)difference(){
union(){
circle(d=mic_id+2*wall);
for (a=[0:360/n:360]) rotate(a) translate([mic_id/2,0]) minkowski() {
square([2*wall+2*wiggle_room,wall+2*wiggle_room],center=true);
circle(d=2*wall);
}
}
circle(d=mic_id);
for (a=[0:360/n:360]) rotate(a) translate([mic_id/2,0])
square([2*wall+2*wiggle_room,wall+2*wiggle_room],center=true);

}
}

module outer_shell(n=n_beams,d=outer_id,l=outer_length) {
linear_extrude(l,center=true)
{
difference(){
circle(d=d+2*wall);
circle(d=d);
for (a=[0:360/n:360]) rotate(a) translate([d/2+wall,0])
square([2*wall+2*wiggle_room,wall+2*wiggle_room],center=true);
}
intersection() {
circle(d=d+2*wall);
for (a=[0:360/n:360]) rotate(a) translate([d/2+wall,0]) difference() {
minkowski() {
square([2*wall+2*wiggle_room,wall+2*wiggle_room],center=true);
circle(d=2*wall);
}
square([2*wall+2*wiggle_room,wall+2*wiggle_room],center=true);
}
}
}
}

module assembly(){
inner_shell();
for (a=[0:360/n_beams:360]) rotate([0,0,a]) translate([mic_id/2+wall/2,0,0]) rotate([90,0,180]) beam(stoppers=inner_length+2*wiggle_room);
rotate([0,0,-180/n_beams])outer_shell();
for (a=[-180/n_beams:360/n_beams:360]) rotate([0,0,a]) translate([outer_id/2+wall/2,0,0]) rotate([90,0,0]) beam(stoppers=inner_length+2*wiggle_room);
}

assembly();
//beam();
/*
id=60;
h=40;
wall=1.6;
n=7;
d=4;
difference(){
cylinder($fn=n,h=h,d=id+2*wall,center=true);
cylinder($fn=n,h=h+bissl,d=id,center=true);
for (m=[[0,0,0],[0,0,1]]) mirror(m)
for (a=[-90:360/n:360]) rotate([0,0,a])translate([0,id,-h/2+d/2-bissl])cube([d,2*id,d],center=true);
rotate([0,-90,0])cylinder(d=10,h=2*id);
}
*/