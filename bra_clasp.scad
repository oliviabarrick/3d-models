$fn = 100;

function d(a) = a * sqrt(2);
function doffset(a) = -d(a)/2;

module center_cube(width, depth, height) {
    translate([-width/2, -depth/2, 0]) cube([width, depth, height]);
}

module post() {
    translate([0, 0, 1]) cylinder(d=4, h=26);
    cylinder(d1=4, d2=5, h=2);
}

module clasp() {
    test_mode = false;

    difference() {
        translate([0, 10.5, 0]) center_cube(6, 3, 27);
        translate([doffset(2) + 3, 9, 3]) rotate([0, 45, 0]) cube([2, 4, 2]);
        translate([doffset(3) + 3, 11, 3]) rotate([0, 45, 0]) cube([3, 4, 3]);
        translate([doffset(2) - 3, 9, 3]) rotate([0, 45, 0]) cube([2, 4, 2]);
        translate([doffset(3) - 3, 11, 3]) rotate([0, 45, 0]) cube([3, 4, 3]);
    }

    if(!test_mode) {
        translate([0, 5, 0]) post();
        

        intersection() {
            translate([-3, 9, 21]) rotate([90, 0, 0]) half_cube(6, 6, 7);
            translate([0, 7, 21]) wedge(4, 6, 4, 6);
        }
    }
}

module left_clasp() {
    clasp();

    translate([0, 13.5, 9]) center_cube(2, 5, 10);
    
    translate([1, 11.5, 6]) rotate([90, 0, 180]) half_cube(2, 5, 5);

    translate([0, 15.7, 0]) cylinder(d=3, h=27);
}

module right_clasp() {
    clasp();

    translate([0, 15, 23]) difference() {
        union() {
            translate([0, 0, -2]) center_cube(6, 6, 6);
            translate([3, -3, -8]) rotate([90, 0, 180]) half_cube(6, 6, 7);
        }

        translate([0, 0, -10]) cylinder(d=3.6, h=30);
    }

    
    translate([0, 14, 0]) difference() {
        union() {
            translate([0, 1, 0]) center_cube(6, 6, 7);
//            translate([3, 4, 7]) rotate([0, 0, 180]) half_cube(6, 6, 7);
        }

        translate([0, 1, -10]) cylinder(d=3.6, h=30);
        translate([-2, 1, -10]) center_cube(5, 2.3, 30);
    }
}

module half_cube(width, depth, height) {
    difference() {
        cube([width, depth, height]);
        rotate([45, 0, 0]) cube([width*2, depth*2, height*2]);
    }
}

module connector() {
    difference() {
        union() {
            cylinder(d=9, h=2, center=true);
            translate([0, 3.5, -1]) center_cube(9, 6, 2);
        }

        cylinder(d=4, h=4, center=true);
        translate([0, 4.5, -2]) center_cube(6, 7, 4);
    }    

    intersection() {
        union() {
            translate([doffset(2) + 3, 1, 0]) rotate([0, 45, 0]) cube([2, 5.5, 2]);
            translate([doffset(2) + 2.2, 5.5, 0]) rotate([0, 45, 0]) cube([2, 1, 2]);
        }
        translate([0, 3.5, -1]) center_cube(8, 8, 2);
    }
    
    intersection() {
        union() {
            translate([doffset(2) - 3, 1, 0]) rotate([0, 45, 0]) cube([2, 5.5, 2]);
            translate([doffset(2) - 2.2, 5.5, 0]) rotate([0, 45, 0]) cube([2, 1, 2]);
        }
        translate([0, 3.5, -1]) center_cube(8, 8, 2);
    }
}


module wedge(width1, width2, depth, height) {
    linear_extrude(height) {
        polygon([[-width2/2, depth/2], [width2/2, depth/2], [width1/2, -depth/2], [-width1/2, -depth/2]]);
    }
}

translate([0, -10, 0]) {
    //translate([0, 5, 3]) connector();
    left_clasp();
}

translate([0, 20.7, 27]) rotate([0, 180, 180]) {
    //translate([0, 5, 3]) connector();
    //right_clasp();
}