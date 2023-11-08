$fn = 100;
eps = 0.01;

thickness = 4;
inner_joint_width = 29.2 + thickness;

connector_width = inner_joint_width;

module ring(x=0, y=0, z=0, h=2, d, d1, d2, thickness=thickness) {
    difference() {
        translate([x, y, z]) cylinder(h=h, d=d, d1=d1, d2=d2);
        translate([x, y, z-eps])
        cylinder(h  = h + eps * 2,
                 d  = d ? d-thickness : d,
                 d1 = d1 ? d1-thickness : d1,
                 d2 = d2 ? d2-thickness : d2);
    }
}

d = 25.3 + thickness;


ring(h=7, d=d);

translate([0, 0, -4]) ring(h=4, d1=connector_width, d2=d, thickness=thickness);
translate([0, 0, -14]) ring(h=10, d=connector_width);
