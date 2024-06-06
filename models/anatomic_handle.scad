back=[0,-0.025242,-0.043981,-0.056793,-0.064251,-0.066928,-0.065398,-0.060235,-0.052013,-0.041304,-0.028684,-0.014724,0,0.014915,0.029448,0.043025,0.055072,0.065016,0.072283,0.076298,0.076489,0.072283,0.063104,0.04838,0.027536,0,-0.033767,-0.069163,-0.10055,-0.12229,-0.12874,-0.11427,-0.073234,0,0.10977,0.25523,0.43422,0.64458,0.88417,1.1508,1.4424,1.7567,2.0917,2.445,2.8147,3.1985,3.5944,4,4.4132,4.8312,5.2511,5.67,6.0849,6.4931,6.8916,7.2775,7.6479,8,8.3313,8.6419,8.9321,9.2025,9.4534,9.6855,9.8991,10.0947,10.2728,10.4339,10.5784,10.7067,10.8195,10.9171,11,11.0686,11.1231,11.1637,11.1904,11.2034,11.2028,11.1887,11.1612,11.1205,11.0668,11,10.9204,10.828,10.7231,10.6057,10.4759,10.3339,10.1798,10.0137,9.8357,9.646,9.4447,9.2319,9.0077,8.7723,8.5258,8.2684,8];
front=[10,8.8,7.7802,6.9292,6.2358,5.6886,5.2762,4.9874,4.8108,4.7351,4.749,4.841,5,5.2145,5.4733,5.765,6.0783,6.4019,6.7243,7.0344,7.3207,7.572,7.7769,7.9241,8.0022,8,7.9125,7.7602,7.5703,7.3696,7.1853,7.0442,6.9735,7,7.1433,7.3926,7.7296,8.1362,8.5938,9.0844,9.5896,10.0912,10.5708,11.0102,11.3911,11.6952,11.9043,12,11.9714,11.8367,11.6214,11.3511,11.0511,10.747,10.4644,10.2286,10.0654,10,10.0512,10.2103,10.4617,10.7897,11.1788,11.6134,12.0779,12.5567,13.0343,13.495,13.9232,14.3035,14.62,14.8574,15,15.0376,14.9813,14.848,14.6542,14.4164,14.1515,13.8759,13.6063,13.3594,13.1517,13,12.9173,12.9029,12.9526,13.062,13.2271,13.4435,13.7069,14.0133,14.3583,14.7376,15.1472,15.5826,16.0397,16.5142,17.0019,17.4986,18];
$fn=64;
extra=0;
difference() {
  for (xb=[0:99]) {
    hull() {
    translate([back[xb+1],0,xb+1])cylinder(h=0.001,d=30);
    translate([back[xb],0,xb])cylinder(h=0.001,d=30);
    translate([front[xb+1]+extra,0,xb+1])cylinder(h=0.001,d=30);
    translate([front[xb]+extra,0,xb])cylinder(h=0.001,d=30);
    }
  }
 * translate([8,0,4])cylinder(d=16,h=100);
}