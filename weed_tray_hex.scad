difference() {
    minkowski() {
        cylinder(h=10, d=200, $fn=6);
    	cylinder(d=1, h=0.1, $fn=100);
    }
    translate([0, 0, 1]) cylinder(h=20, d=196, $fn=6);
}
