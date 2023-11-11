$fn=100;

module talon(lower_ring_size=17, upper_ring_size=15) {
    width=upper_ring_size;
    height=40;
    ringw = lower_ring_size+4;

    difference() {
        union() {
            cylinder(d=ringw, h=5);
            translate([-(upper_ring_size/2), 0, 0]) {
                cylinder(d=width, h=25);
                translate([0, 0, 25]) difference() {
                    cylinder(d1=width, d2=2, h=height);
                    translate([width/2, 0, 0]) cylinder(d=width, h=height);
                }
            }
            //cylinder(d=21, h=5);
            translate([0, 0, 4]) difference() {
                cylinder(d=ringw, h=21);
                translate([lower_ring_size * 1.3, 0, -5]) rotate([0, -60, 0]) cube([ringw*2, ringw*2, ringw*2], center=true);
            }
        }

        cylinder(d1=lower_ring_size, d2=width, h=25);
    }

}

// standard
talon(17, 15);
translate([30, 0, 0]) talon(17, 15);
translate([60, 0, 0]) talon(17, 15);

// pinky
translate([0, 30, 0]) talon(15, 13);

// thumb
translate([30, 30, 0]) talon(21, 18);