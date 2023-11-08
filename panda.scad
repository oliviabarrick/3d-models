$fn = 100;

/*
translate([0, 0, 2]) linear_extrude(2) text("panda", size=16, halign="center", valign="center");
*/

color("grey") {
    cube([70, 24, 4], center=true);
    translate([-35, 12, 0]) cylinder(h=4, d=30, center=true);
    translate([-35, -12, 0]) cylinder(h=4, d=30, center=true);
    translate([35, 12, 0]) cylinder(h=4, d=30, center=true);
    translate([35, -12, 0]) cylinder(h=4, d=30, center=true);

    difference() {
        union() {
            cube([70, 24, 6], center=true);
            translate([-35, 12, 0]) cylinder(h=6, d=30, center=true);
            translate([-35, -12, 0]) cylinder(h=6, d=30, center=true);
            translate([35, 12, 0]) cylinder(h=6, d=30, center=true);
            translate([35, -12, 0]) cylinder(h=6, d=30, center=true);
        }
    
        union() {
            cube([68, 22, 8], center=true);
            translate([-35, 12, 0]) cylinder(h=8, d=28, center=true);
            translate([-35, -12, 0]) cylinder(h=8, d=28, center=true);
            translate([35, 12, 0]) cylinder(h=8, d=28, center=true);
            translate([35, -12, 0]) cylinder(h=8, d=28, center=true);
        }
    }
    
    difference() {
        translate([0, 12, 0]) cylinder(h=4, d=14, center=true);
        translate([0, 12, -1]) cylinder(h=7, d=10, center=true);
    }
}

/*
translate([0, 5, -4]) {
    mirror([1, 0, 0]) linear_extrude(2) text("Ollie - 415-889-7202", size=5, halign="center", valign="center");
}

translate([0, -5, -4]) {
    mirror([1, 0, 0]) linear_extrude(2) text("Skylar - 415-996-5200", size=5, halign="center", valign="center");
}
*/