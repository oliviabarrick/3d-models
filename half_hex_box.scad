module half_cylinder(h=10, d=10) {
    difference() {
        cylinder(h=h, d=d, $fn=6);
        translate([-(d / 2), 0, 0]) cube([d, d, h]);
    }
}

d=40;
h=70;
padding = 2;
dpad = d - padding*2;

difference() {
    half_cylinder(h=h, d=d);
    translate([0, 0, padding]) half_cylinder(h=h, d=dpad);
}

translate([-(dpad / 2), -padding, 0]) cube([dpad, padding, h]);