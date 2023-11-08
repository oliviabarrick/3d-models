$fn = 100;

module pod(diameter=18.5, padding=4, number_inserts=5, height=25, base_offset=5) {
    radius = diameter / 2;

    difference() {
        cube([(diameter + padding) * number_inserts + padding, diameter + (padding * 2), height + base_offset]);

        for (i = [0:number_inserts - 1]) {
            translate([
                radius + padding + ((diameter + padding) * i),
                radius + padding,
                base_offset
            ]) cylinder(d=diameter, h=26, center=false);
        }
    }
}

diameter = 18.5;
padding = 4.5;
number_inserts = 5;
deoderant_diameter = 47;

offset = (diameter + padding) * number_inserts + padding;

translate([offset, 0, 0]) pod(diameter=deoderant_diameter, padding=4, number_inserts=1);

pod(diameter=diameter, padding=padding, number_inserts=number_inserts);
translate([0, diameter + (padding * 2), 0]) {
    pod(diameter=diameter, padding=padding, number_inserts=number_inserts, base_offset=15);
}