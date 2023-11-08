use <MCAD/screw.scad>;

// resolution, increase for less flat lines
$fn = 1000;

eps = 0.01;
diameter = 22;
thickness = 2;

module ring(x=0, y=0, z=0, height, d, d1, d2, thickness=thickness) {
    difference() {
        translate([x, y, z]) cylinder(h=height, d=d, d1=d1, d2=d2);
        translate([x, y, z-eps])
        cylinder(h  = height + eps * 2,
                 d  = d ? d-thickness : d,
                 d1 = d1 ? d1-thickness : d1,
                 d2 = d2 ? d2-thickness : d2);
    }    
}

module bong_connector() {
    ring(height=20, d1=12, d2=diameter);
}

module bowl() {
    difference() {
        ring(z=20, height=10, d=diameter);
        translate([0, 0, 25]) rotate(a=90, v=[0,1,0]) cylinder(d=5, h=diameter);
    }

    ring(z=30, height=2, d=diameter+thickness);
    ring(z=32, height=10, d=diameter);
    
    ;
}

bong_connector();
bowl();