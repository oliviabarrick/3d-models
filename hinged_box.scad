$fn = 100;
thickness = 2;
eps = 0.01;

module half_sphere(r) {
    difference() {
        sphere(r=r);
        translate([0, 0, r / 2]) cube([r*2, r*2, r], center=true);
    }
}

module hinge_piece(hole=false) {
    difference() {
        union() {
            cylinder(d=2, h=1, center=false);
            translate([-2, -1, 0]) cube([1.9, 2.1, 1], center=false);
        }
    
        if (hole) {
            translate([0, 0, -1]) cylinder(d=1, h=3, center=false);
        }
        
        translate([-3, -4, -1]) rotate([0, 0, 45]) cube([4, 4, 3], center=false);    
    }
}

module hinge() {
    color("green") translate([0, 0, -1.1]) hinge_piece(hole=false);
    color("green") translate([0, 0, -1]) cylinder(d=0.8, h=3, center=false);
    mirror([1, 0, 0]) translate([0, 0, 0]) hinge_piece(hole=true);
    color("green") translate([0, 0, 1.1]) hinge_piece(hole=false);    
}

module tray(width=0, depth=0, height=0, thickness=thickness, rounded_radius=10) {
    difference() {
        minkowski() {
            cube([width, depth, height], center=false);
            half_sphere(r=rounded_radius);
        }
        
        color("blue") minkowski() {
            translate([thickness/2, thickness/2, thickness - 1]) cube([
                width - thickness, depth - thickness, height * 2
            ], center=false);
            half_sphere(r=rounded_radius);
        }
    }
}

module hinged_box(width=10, depth=10, box_height=8, lid_height=2, rounded_radius=2, thickness=2) {
    assert(depth > thickness);

    buffer = 0.1;

    tray_width = width;
    tray_depth = depth;

    tray(width=tray_width, depth=tray_depth, height=box_height - buffer, rounded_radius=rounded_radius, thickness=thickness);
    translate([tray_width, 0, box_height + lid_height]) rotate(a=[0, 180, 0]) tray(width=tray_width, depth=tray_depth, height=lid_height, rounded_radius=rounded_radius, thickness=thickness);


    translate([
        width > 8 ? 3 : width / 2 + 0.5, -1.1 - rounded_radius, box_height
    ]) rotate(a=[0, 270, 0]) hinge();
    
    if (width > 8) {
        translate([
            width - 2, -1.1 - rounded_radius, box_height
        ]) rotate(a=[0, 270, 0]) hinge();
    }
}

hinged_box(width=40, depth=40, box_height=30, lid_height=10, rounded_radius=10, thickness=2);