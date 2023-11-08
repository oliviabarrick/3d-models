module hexagon(d=10, h=10) {
    cylinder(d=d, h=h, $fn=6);
}

module catan_tile() {
    diameter = 89;
    max_road_width = 8;
    inner_diameter = diameter - max_road_width;

    difference() {
        hexagon(d=89, h=3);
        translate([0, 0, -0.1]) hexagon(d=inner_diameter + 1, h=2.1);
    }

    translate([0, 0, 3]) hexagon(d=inner_diameter, h=2.1);
}

catan_tile();