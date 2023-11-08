$fn = 100;

module center_cube(width, depth, height) {
    translate([-width/2, -depth/2, 0]) cube([width, depth, height]);
}

module clasp() {
    translate([0, 10.5, 0]) cylinder(d=4, h=27);
    translate([0, 7, 0]) center_cube(4, 6.5, 4);
    translate([0, 4, 0]) difference() {
        cylinder(d=4, h=27);
        translate([0, 0, 12]) cylinder(d=5, h=3);
    }  
    translate([0, 7, 23]) center_cube(4, 6.5, 4);
}

module left_clasp() {
    clasp();
    translate([0, 10.5, 0]) center_cube(4, 4, 27);
    translate([0, 13.5, 6.5]) center_cube(2, 5, 14);
    translate([0, 17.5, 0]) cylinder(d=4, h=27);
}

module right_connector(with_notch=false) {
    difference() {
        union() {
            translate([-2, 2, 0]) cylinder(d=8, h=6);
            translate([0, 0, 0]) center_cube(4, 4.5, 6);
            translate([-2, 4, 0]) center_cube(8, 4, 6);
        }
        if(with_notch) translate([-5, 2, -8]) center_cube(5, 2.3, 30);
    }
}

module right_clasp() {
    clasp();

    difference() {
        union() {
            translate([0, 13, 21]) right_connector(true);
            translate([0, 13, 0]) right_connector();
        }
        translate([-2, 15, -1]) cylinder(d=4.6, h=30);
    }
}

translate([-2, -11.2, 0]) left_clasp();
translate([0, 21.3, 27]) rotate([180, 0, 0]) right_clasp();