module hex_wedge(h=10, d=10) {
    difference() {
        cylinder(h=h, d=d, $fn=6);
        translate([-(d/4), -(d/2), 0]) cube([d, d, h]);
    }
}

d=80;
h=50;
padding = 2;
dpad = d - padding*2;

difference() {
    hex_wedge(h=h, d=d);
    translate([0, 0, padding]) hex_wedge(h=h, d=dpad);
}

height = (sqrt(3) / 2) * (d);

translate([- d/4 -(padding/2), 0, h/2]) cube([padding, height - padding*4 + 1, h], center=true);