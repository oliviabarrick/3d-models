minkowski() {
    difference() {
        cylinder(h=10, d=200, $fn=6);
        translate([0, 0, 1]) cylinder(h=20, d=196, $fn=6);
        
    }
    sphere(d=1, $fn=100);
}