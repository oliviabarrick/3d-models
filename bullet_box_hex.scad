function long_diagonal(short_diagonal) = 2 * (short_diagonal / sqrt(3));
function short_diagonal(long_diagonal) = long_diagonal / 2 * sqrt(3);

module hex_arrange(hex_offset, max_angle=300) {
    for(angle = [0 : 60 : max_angle]) {
        rotate([0, 0, angle]) translate([0, hex_offset, 0]) children();
    }
}

module magnet() {
    cylinder(d=6.2, h=2.2, center=true, $fn=100);
}

module magnets(hex_offset) {
    rotate([0, 0, 30]) hex_arrange(hex_offset) magnet();
}


module engrave(t, size) {
    linear_extrude(height=2) text(t, font="Calibri", size=size, halign="center", valign="center");
}

module post(h, d) {
    rotate([90, 0, 0]) cylinder(h=h, d=d, center=true, $fn=100);
}

module bullet_hole(bullet_diameter, bullet_height) {
    cylinder(d=bullet_diameter + 0.3, h=bullet_height, $fn=100, center=true);
}

module create_table(x_items, y_items, offset) {
    x_start = (offset/2) * (x_items-1);
    y_start = (offset/2) * (y_items-1);

    for(x = [-x_start : offset : x_start]) {
        for(y = [-y_start : offset : y_start]) {
            translate([x, y, 0]) children();
        }
    }
}

module bullet_box(bullet_diameter, bullet_height, mag_size, num_mags, engraving) {
    height = bullet_height * 0.7;
    spot_size = bullet_diameter + 2;
    y = spot_size * num_mags + 2;
    x = spot_size * mag_size + 4;

    bullet_offset = (bullet_height - height) / 2 + 2;
  
    difference() {
        minkowski() {
            cube([x-1, y-1, height+2-1], center=true);
            sphere(d=1);
        }
        translate([0, -y/2+1, 0]) rotate([90, 0, 0]) engrave(engraving, 15);
        create_table(mag_size, num_mags, spot_size) translate([0, 0, bullet_offset]) bullet_hole(bullet_diameter, bullet_height);
        translate([-x/2, 0, height/2 - 2]) post(y, 2);
        translate([x/2, 0, height/2 - 2]) post(y, 2);
    }
}

module bullet_lid(bullet_diameter, bullet_height, mag_size, num_mags, engraving) {
    height = bullet_height * 0.4 + 5;
    spot_size = bullet_diameter + 2;
    y = spot_size * num_mags + 2 + 2;
    x = spot_size * mag_size + 4 + 4.2; 

    difference() {
        minkowski() {
            union() {
                cube([x-1, y-1, 2-1], center=true);
                translate([-x/2+1, 0, -height/2+1]) cube([2-1, y-1, height-2-1], center=true);
                translate([x/2-1, 0, -height/2+1]) cube([2-1, y-1, height-2-1], center=true);
                translate([0, y/2-1, -height/2+1]) cube([x-1, 2-1, height-2-1], center=true);
            }
            sphere(d=1);
        }
        engrave(engraving, 20);
    }

    translate([-x/2+2, 0, -height+3.5]) post(y-1, 2);
    translate([x/2-2, 0, -height+3.5]) post(y-1, 2);
}

module bullet_box_380(mag_size, num_mags, engraving) {
    bullet_box(9.5, 25, mag_size, num_mags, engraving);
}

module bullet_lid_380(mag_size, num_mags, engraving) {
    bullet_lid(9.5, 25, mag_size, num_mags, engraving);
}

//bullet_box_380(6, 4, ".380");
//translate([0, 0, 18.25]) bullet_lid_380(6, 4, "olivia");

module bullet_triangle(rows, bullet_diameter, bullet_height) {
    hole_offset = bullet_diameter + 2;
    hole_offset_h = hole_offset / 2;

    center_offset = hole_offset * rows;
    center_offset_h = center_offset / 2;

    for(y = [1:rows]) {
        for(x = [1:y]) {
            translate([
              x*hole_offset + (rows-y-1)*hole_offset_h - center_offset_h,
              y*hole_offset - hole_offset_h - center_offset_h,
              0
             ]) bullet_hole(bullet_diameter, bullet_height);
        }
    }
}

module bullet_base(base_diameter, offset, rows, bullet_diameter, bullet_height, engraving) {
    base_height = bullet_height * 0.7;

    difference() {
        cylinder(d=base_diameter + 10, h=base_height, center=true, $fn=6);
        translate([0, 0, 5.5]) hex_arrange(offset, max_angle=299) bullet_triangle(rows, bullet_diameter, bullet_height);
        translate([0, 0, (base_height / 2) - 2]) magnets(base_diameter / 2);
        translate([0, 0, 2]) cylinder(d=3.2, h=base_height, center=true, $fn=100);
        translate([0, 0, base_height / 2 - 2.7 - 4]) cylinder(d=long_diagonal(5.7), h=2.7, center=false, $fn=6);
    }

    rotate([0, 0, -60]) translate([0, 32, base_height/2-1.5]) engrave(engraving, 15);
}

module bullet_lid(base_diameter, bullet_diameter, bullet_height, engraving) {
    base_height = bullet_height - (bullet_height * 0.7) + 2;

    difference() {
        union() {
            difference() {
                union() {
                    translate([0, 0, base_height]) difference() {
                        cylinder(d=base_diameter + 10, h=2, $fn=6);
                        rotate([0, 0, 30]) translate([-50, 0, 0]) cylinder(d=100, h=base_height, $fn=3);              
                    }

                    difference() {
                        cylinder(d=base_diameter + 10, h=base_height+2, $fn=6);
                        cylinder(d=base_diameter, h=base_height+2, $fn=6);
                    }
                
                    rotate([0, 0, 30]) hex_arrange(base_diameter / 2) cylinder(d=7, h=base_height+2, $fn=100);
                
                    cylinder(d=6, h=base_height+2, $fn=100);
                }
                translate([0, 0, 2]) magnets(base_diameter / 2);
                rotate([0, 0, 120]) translate([0, -20, base_height+1]) engrave(engraving, 20);
            }

            rotate([0, 0, 90]) translate([0, 0, base_height/2]) cube([2, base_diameter/2, base_height/2]);
        }
        cylinder(d=3.2, h=base_height+2, $fn=100);
    }
}

//rotate([0, 0, 180]) translate([0, 0, 19]) bullet_lid(100, 9.5, 25, "olivia");
bullet_base(100, 25, 3, 9.5, 25, ".380");