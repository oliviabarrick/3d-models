$fn = 100;

scope_test = 0;

module ring(diameter=0, height=0) {
    difference() {
        translate([0, 0, height / 2]) cube([diameter + 4, diameter + 4, height], center=true);
        translate([0, 0, -1]) cylinder(d=diameter, h=height + 2);
        translate([0, -diameter / 2 - 1, height / 2]) rotate([90, 0, 0]) linear_extrude(6) text(str(diameter), size=2, halign="center", valign="center");    
    }
    
    
    translate([0, diameter / 2 + 2, 1.5]) difference() {
        cylinder(d=4, h=1);
        translate([0, 0, -1]) cylinder(d=3, h=3);
        translate([0, -2, 0]) cube([4, 4, 4], center=true);
    }

}

for (y = [1:3]) {
    base_diameter = 10 + y * 2.5;

    for (i = [0:0.5:2.5]) {
        translate([25 * i * 2, y * 25, 0]) ring(diameter=base_diameter + i, height=4);
    }
}