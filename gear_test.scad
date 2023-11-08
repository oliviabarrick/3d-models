include <gears.scad>

module m3_nut() {
    cylinder(d=6.6, h=3, $fn=6, center=true);
}

module car_gear(height) {
    spur_gear(modul=1, tooth_number=20, width=height, bore=0, pressure_angle=20, helix_angle=0, optimized=false);    
}

module dc_motor_gear(height) {
    spur_gear(modul=0.6, tooth_number=10, width=height, bore=0, pressure_angle=20, helix_angle=0, optimized=false);
}

module motor_attached_gear(height) {
    difference() {  
        car_gear(height);
        dc_motor_gear(height);
    }
}

module motor_peg_attached_gear(height) {
    difference() {  
        car_gear(height);
        cylinder(height, d=2);
    }
}

module shaft_gear(height, shaft_thickness) { 
    difference() {
        car_gear(height);
        cube([shaft_thickness, shaft_thickness, 10], center=true);
    }
}

module servo_mount_gear(height, shaft_thickness) { 
    difference() {
        cylinder(height, d=10, center=true);
        cube([shaft_thickness, shaft_thickness, 10], center=true);
    }
}

module wheel(diameter, thickness, shaft_thickness) {
    difference() {
        union() {
            cylinder(h=1, d=diameter+2);
            translate([0, 0, 1]) cylinder(h=thickness+1, d=diameter);
            translate([0, 0, 2+thickness])  cylinder(h=1, d=diameter+2);
            translate([0, 0, 3+thickness]) cylinder(h=thickness, d=shaft_thickness*2 + 3);
            translate([0, 0, 3+thickness*2]) cylinder(h=thickness, d=shaft_thickness + 2.8);
        }
        translate([-(shaft_thickness/2), -(shaft_thickness/2), 1]) cube([shaft_thickness, shaft_thickness, 100]);
    }
}

module shaft(length, thickness, center=true) {
    cube([thickness-.2, length, thickness-.2], center=center);
}

module gear_housing(gear_diameter, gear_height, shaft_thickness, motor_gear_diameter) {
    gear_radius = gear_diameter / 2;
    gear_height = gear_height + 0.5;
    thickness = gear_height + 2;
    shaft_hole = shaft_thickness + 3;

    difference() {
        cube([gear_diameter*2+2, gear_height + 2, gear_diameter+2], center=true);
        translate([gear_radius, 0, 0]) rotate([90, 90, 0]) cylinder(h=gear_height, d=gear_diameter+1, center=true);
        cube([gear_diameter+1, gear_height, gear_diameter+1], center=true);
        translate([-gear_radius, 0, 0]) rotate([90, 90, 0]) cylinder(h=gear_height, d=gear_diameter+1, center=true);
        translate([0, -((gear_height + 2)/2), 0]) cube([gear_diameter+2, gear_height + 2, gear_radius+1]);

        translate([-gear_radius+1, 0, 0]) rotate([90, 90, 0]) cylinder(h=10, d=motor_gear_diameter + 1, center=true);
        translate([gear_radius-1, 0, 0]) rotate([90, 90, 0]) cylinder(h=10, d=shaft_hole, center=true);
    }

    difference() {
        translate([gear_radius+0.5, 0, 0]) cube([gear_diameter+1, thickness, shaft_hole+2], center=true);
        translate([gear_radius, 0, 0]) cube([gear_diameter+1, thickness-2, shaft_hole+2], center=true);
        translate([gear_radius-1, 0, 0]) rotate([90, 90, 0]) cylinder(h=10, d=shaft_hole, center=true);
        translate([gear_radius, 0, 0]) rotate([90, 90, 0]) cylinder(h=gear_height, d=gear_diameter+1, center=true);
    }
    
    translate([gear_diameter+4, 0, -9]) {
        difference() {
            translate([0, 0, -1]) cube([gear_height + 2, gear_height + 2, 4], center=true);
            cylinder(d=3.2, h=100, center=true);
        }
    }

    translate([-gear_diameter-4, 0, -9]) {
        difference() {
            translate([0, 0, -1]) cube([gear_height + 2, gear_height + 2, 4], center=true);
            cylinder(d=3.2, h=100, center=true);
        }
    }
}

module tire(height, diameter) {
    r = diameter / 2;
    hr = r / 2;

    difference() {
        cylinder(h=height, r=r);
        for (i = [0:30:360]) {
            rotate([0, 0, i]) {
                translate([r, 0, 0]) {
                    cube([1, hr / 2, height], center=true); // Cutout cube
                }
            }
        }
        for (i = [15:30:360]) {
            rotate([0, 0, i]) {
                translate([r, 0, height]) {
                    cube([1, hr / 2, height], center=true); // Cutout cube
                }
            }
        }
    }
}

module servo_nub(height=2, center=true) {
    length = 17.4;
    big_d = 7.4;
    small_d = 3.4;

    big_r = big_d / 2;
    small_r = small_d / 2;

    small_offset = length - big_r - small_r;

    translate([center ? -(length/2) + big_r : 0, 0, 0]) union() {
        cylinder(h=height, d=big_d, center=center);
        translate([small_offset, 0, 0]) cylinder(h=height, d=small_d, center=center);

        translate([0, 0, center ? -height/2 : 0]) linear_extrude(height) polygon(points=[
            [0,-big_r],
            [0,big_r],
            [small_offset, small_r],
            [small_offset,-small_r]
        ]);
    }
}

module front_axel(height=2, shaft_thickness=4) {
    shaft_hole = shaft_thickness + 3;

    h = 20;

    difference() {
        cube([25, 15, h], center=true);
        translate([0, 0, (h / 2) - 1]) servo_nub(2, center=true);     
        translate([0, 0, -1]) rotate([90, 90, 0]) cylinder(h=20, d=shaft_hole, center=true);
        translate([0, 0, -2]) cube([12, 5.6, 18], center=true);
    }
}

module motor_shape(x, y, z) {
    intersection() {
        cube([x, y, z], center=true);
        rotate([90, 90, 0]) cylinder(h=y, d=z, center=true);
    }
}

module motor_housing() {
    difference() {
        cube([29, 29, 26], center=true);

        motor_shape(15, 25, 20);

        rotate([90, 90, 0]) cylinder(h=100, d=12, center=true);

        //translate([-13, 0, -12]) m3_nut();
        //translate([13, 0, -12]) m3_nut();
        
        translate([-11, 2, 0]) cylinder(d=3.2, h=100, center=true);
        translate([11, 2, 0]) cylinder(d=3.2, h=100, center=true);
        translate([0, -7, 0]) cube([100, 10, 20], center=true);    
    }
    
    
}

module motor_housing_top() {
    difference() {
        motor_housing();
        translate([0, 0, -6.5]) cube([36, 30, 13], center=true);
    }
}

module motor_housing_bottom() {
    difference() {
        motor_housing();
        translate([0, 0, 6.5]) cube([36, 30, 13], center=true);
    }
}

module car_body() {
    translate([30, 30, 3]) gear_housing(gear_diameter = gear_diameter, gear_height = gear_height, shaft_thickness = shaft_thickness, motor_gear_diameter = motor_gear_diameter);

    translate([0, 0, 0]) difference() {
        cube([120, 70, 20], center=true);
        translate([0, 0, 2]) cube([116, 66, 20], center=true);

        translate([40, 0, 3]) rotate([90, 90, 0]) cylinder(h=100, d=7.2, center=true);

        translate([20, -5, 0]) cube([22, 60, 26], center=true);

        translate([20, 0, 3]) rotate([90, 90, 0]) cylinder(h=100, d=shaft_thickness + 3, center=true);

        translate([-60, -5, 6]) rotate([90, 0, 90]) cylinder(d=3.2, h=6, center=true);
        translate([-60, 5, 6]) rotate([90, 0, 90]) cylinder(d=3.2, h=6, center=true);
    }

    translate([20, -4, 3]) difference() {
        cube([26, 62, 26], center=true);

        intersection() {
            translate([0, -1, 0]) cube([18.7, 62, 24.4], center=true);
            translate([0, -1, 0]) rotate([90, 90, 0]) cylinder(h=62, d=24.4, center=true);
        }

        rotate([90, 90, 0]) cylinder(h=100, d=shaft_thickness + 3, center=true);
        translate([0, -18, 0]) cube([30, 4, 4], center=true);    
        translate([0, -24, 0]) cube([30, 4, 4], center=true);    
    }
}

module servo_mount_top() {
    difference() {
        cube([35, 35, 5], center=true);
        cube([25, 14, 5], center=true);

        translate([0, 12, 0]) cylinder(d=3.2, h=6, center=true);
        translate([0, -12, 0]) cylinder(d=3.2, h=6, center=true);

        translate([0, 0, 1.25]) cube([40, 12.2, 2.5], center=true);
    } 
}

module servo_mount() {
    difference() {
        translate([-15, 0, 5]) cube([5, 35, 12], center=true);
        translate([-13, -5, 6]) rotate([90, 90, 90]) m3_nut();
        translate([-13, 5, 6]) rotate([90, 90, 90]) m3_nut();
        translate([-15, -5, 6]) rotate([90, 0, 90]) cylinder(d=3.2, h=6, center=true);
        translate([-15, 5, 6]) rotate([90, 0, 90]) cylinder(d=3.2, h=6, center=true);
    }

    difference() {
        cube([35, 35, 5], center=true);
        cube([23.8, 12.2, 5], center=true);
        
    
        translate([0, 12, 1]) m3_nut();
        translate([0, -12, 1]) m3_nut();
        
        translate([0, 12, 0]) cylinder(d=3.2, h=6, center=true);
        translate([0, -12, 0]) cylinder(d=3.2, h=6, center=true);
    }
}

wheel_diameter = 30;
wheel_thickness = 4;

shaft_length = 80;
shaft_thickness = 4;

gear_diameter = 22;
gear_height = 4;

motor_gear_diameter = 6;

//front_axel();
//car_body();
//motor_housing_bottom();
//translate([0, 0, 5]) motor_housing_top();

gear_housing(gear_diameter = gear_diameter, gear_height = gear_height, shaft_thickness = shaft_thickness, motor_gear_diameter = motor_gear_diameter);


//servo_mount_gear(height = 5.4, shaft_thickness = shaft_thickness);
//servo_mount();

//translate([0, 0, -10]) servo_mount_top();

//motor_attached_gear(height = gear_height - .5);
//motor_peg_attached_gear(height = gear_height);

/*
translate([25, 0, 0]) shaft_gear(height = gear_height, shaft_thickness = shaft_thickness);

wheel(wheel_diameter, wheel_thickness, shaft_thickness);

difference() {
    tire(wheel_thickness, wheel_diameter + wheel_diameter/2);
    translate([0, 0, wheel_thickness/2]) cylinder(d=wheel_diameter, h=wheel_thickness, center=true);
}
*/

//wheel(wheel_diameter, wheel_thickness, shaft_thickness);

// translate([70, 50, 1]) shaft(length = shaft_length, thickness = shaft_thickness, center = true);

