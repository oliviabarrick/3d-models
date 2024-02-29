function long_diagonal(short_diagonal) = 2 * (short_diagonal / sqrt(3));
function short_diagonal(long_diagonal) = long_diagonal / 2 * sqrt(3);

module road() {
    cube([5.7, 5.7, 25], center=true);
}

module settlement(width=14) {
    translate([-5.25, -8, -7]) linear_extrude(width) polygon(points = [
        [0, 0],
        [10, 0],
        [10, 10],
        [5, 14],
        [0, 10],
        [0, 0]
    ]);
}

module city_wall() {
    cube([21.7, 5.7, 21], center=true);
}

module city() {
    translate([0, 0, 1]) cube([10.5, 20.5, 12], center=true);
    translate([1.75, -5, 10]) rotate([90, 0, 90]) settlement(width=10.5);
}

module knight() {
    rotate([90, 0, 90]) cylinder(d=20.5, h=6.5, center=true, $fn=100);
}

module roads() {
    distance = 7;
    
    rotate([0, 0, 90]) for(y = [-distance*2 : distance : distance*2]) {
        translate([0, y, 0]) road();
    }
}

module settlements() {
    translate([0, 6, 0]) rotate([0, 0, 180]) { 
        translate([-12, 0, 0]) settlement();
        translate([12, 0, 0]) settlement();
        translate([0, 0, 0]) settlement();
        translate([-24, 0, 0]) settlement();
        translate([24, 0, 0]) settlement();
    }
}


module city_walls() {
    translate([0, 34, 0]) city_wall();
    translate([-35, 0, 0]) rotate([0, 0, 90]) city_wall();
    translate([35, 0, 0]) rotate([0, 0, 90]) city_wall();
}

module cities() {
    translate([18, 0, 0]) city();
    translate([6, 0, 0]) city();
    translate([-6, 0, 0]) city();
    translate([-18, 0, 0]) city();
}

module knights() {
    translate([8, 0, 0]) knight();
    knight();
    translate([-8, 0, 0]) knight();
}

module hex(d, h) {
    cylinder(d=long_diagonal(d) , h=h, $fn=6, center=true);
}

module hex_cone(d1, d2, h) {
    cylinder(d1=long_diagonal(d1), d2=long_diagonal(d2), h=h, $fn=6, center=true);
}

module magnet() {
    cube([6, 6, 1.9], center=true);
}

module magnet_set() {
    translate([0, -45, 0]) magnet();
    translate([0, 45, 0]) magnet();
}

module magnets() {
    magnet_set();
    rotate([0, 0, 60]) magnet_set();
    rotate([0, 0, -60]) magnet_set();
}

module pyramid() {
    cylinder(h=2, d1=10, d2=2, $fn=6);
}

module pyramids(layoutOffset) {
    sideLength = layoutOffset - 0.1;

    for(angle = [0 : 60 : 360]) translate([sideLength * cos(angle), sideLength * sin(angle), 0]) pyramid();
}

module pyramidLayout() {
    pyramids(10);
    pyramids(20);
    pyramids(30);
    pyramids(40);
    pyramids(50);
}

/*
difference() {
    union() {
        translate([0, 0, -4]) hex(95, 8);
        translate([0, 0, 5]) hex(80, 10);
    }

    translate([0, 0, 10]) {
        translate([28, -6, -3]) rotate([0, 0, 90]) roads();
        translate([-28, -6, -3]) rotate([0, 0, 90]) roads();

        translate([0, 29, 2.5]) rotate([0, 0, 180]) settlements();
        translate([0, 0, -1]) city_walls();

        translate([-12, -20, -1.5]) rotate([0, 0, 0]) knights();
        translate([12, -20, -1.5]) rotate([0, 0, 0]) knights();

        translate([0, -34, -3]) roads();

        translate([0, 2, -5.5]) cities();
    }
    
    translate([0, 0, -1.75]) magnets();
    translate([0, 0, -8.1]) pyramidLayout();
}*/

module lid_base() {
    inside_wall = long_diagonal(81)/2;
    outside_wall = long_diagonal(95)/2;
    wall_offset = (outside_wall-inside_wall)/2;
    s = wall_offset + inside_wall;

    difference() {
        union() {
            hex(95, 20);
            translate([0, 0, 10]) for(angle = [0 : 60 : 360]) translate([s * cos(angle), s * sin(angle), 0]) cylinder(h=2.1, d=3.2, $fn=100);
        }

        translate([0, 0, 1]) hex(81, 22);
        translate([0, 0, -8.5]) magnets();
    }
}

//lid_base();

translate([0, 0, 40]) {
    difference() {
        hex(95, 4);
        translate([0, 0, -12.1]) lid_base();
    }
    translate([0, 0, 1.9]) pyramidLayout();
}
