module connector2(x=0, y=0, z=0) {
    translate([x-6, y, z]) cube([4, 2, 3], center=true);
}

module connector_hole(x=0, y=0, z=0) {
        translate([x, y, z]) color("blue") cube([8, 2, 3], center=true);    
}

module wedge(width, depth, height, angle) {
    difference() {
        translate([0, 0, 0]) cube([width, depth, height], center=true);
        translate([width/2, 0, 0]) rotate(angle, [0, 1, 0]) cube([width*4, depth*2, height], center=true);
    }
}

module polish_pod(x=0, y=0, z=0, add_wedge=true) {
    difference() {
        translate([x, y, z]) cube([30, 30, 30], center=true);
        translate([x, y, z+5]) cube([28, 28, 32], center=true);
    }

    if (add_wedge) {
        translate([x, y, z-20]) rotate(90, [0, 0, 1]) wedge(30, 30, 10, -9.5);
    }
}

for (y = [0:5]) {
    polish_pod(x=0, y=y*30, z=y*5, add_wedge=(y != 0 && y != 5));
}

add_connectors = true;
add_holes = true;

// back foot
difference() {
    translate([-15, 30*5-15, -25]) cube([30, 30, 35]);

    if (add_holes) {
        // connector holes
        translate([13, 30*5+5, 0]) connector_hole();
        translate([13, 30*5-5, 0]) connector_hole();
        translate([13, 30*5+5, -20]) connector_hole();
        translate([13, 30*5-5, -20]) connector_hole();
    }
}

// front foot
difference() {
    translate([-15, -15, -25]) cube([30, 30, 10]);

    if (add_holes) {
        // connector holes
        translate([13, 5, -20]) connector_hole();
        translate([13, -5, -20]) connector_hole();
    }
}

if (add_connectors) {
    translate([-10, 30*5+5, -20]) connector2();
    translate([-10, 30*5-5, -20]) connector2();

    translate([-10, 30*5+5, 0]) connector2();
    translate([-10, 30*5-5, 0]) connector2();

    translate([-10, 5, -20]) connector2();
    translate([-10, -5, -20]) connector2();
}
