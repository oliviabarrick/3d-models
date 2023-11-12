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
        cube([gear_diameter*2+2, gear_height + 2, gear_diameter+4], center=true);
        translate([gear_radius, 0, 0]) rotate([90, 90, 0]) cylinder(h=gear_height, d=gear_diameter+1, center=true);
        cube([gear_diameter+1, gear_height, gear_diameter+1], center=true);
        translate([-gear_radius, 0, 0]) rotate([90, 90, 0]) cylinder(h=gear_height, d=gear_diameter+1, center=true);
        translate([0, -((gear_height + 2)/2), 0]) cube([gear_diameter+2, gear_height + 2, gear_radius+2]);

        translate([-gear_radius+1, 0, 0]) rotate([90, 90, 0]) cylinder(h=10, d=motor_gear_diameter + 1, center=true);
        translate([gear_radius-1, 0, 0]) rotate([90, 90, 0]) cylinder(h=10, d=shaft_hole, center=true);
        translate([-5, 0, 13]) rotate([45, 0, 90]) cube([100, 13, 10], center=true);
        translate([1, 0, 9.5]) cube([10, 100, 10], center=true);
    }      



    difference() {
        translate([gear_radius+0.5, 0, 0]) cube([gear_diameter+1, thickness, shaft_hole+2], center=true);
        translate([gear_radius, 0, 0]) cube([gear_diameter+1, thickness-2, shaft_hole+2], center=true);
        translate([gear_radius-1, 0, 0]) rotate([90, 90, 0]) cylinder(h=10, d=shaft_hole, center=true);
        translate([gear_radius, 0, 0]) rotate([90, 90, 0]) cylinder(h=gear_height, d=gear_diameter+1, center=true);
    }
    
    translate([gear_diameter+4, 0, -9.5]) screw_hole(h=5, width=gear_height+2);

    translate([-gear_diameter-8, 0, -9.5]) screw_hole(h=5, width=gear_height+2);
    translate([-gear_diameter-3, 0, -10.5]) cube([4, gear_height+2, 5], center=true);
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

module screw_hole(h=10, width=6) {
    difference() {
        translate([0, 0, -1]) cube([width, width, h], center=true);
        cylinder(d=3.2, h=100, center=true);
    }
}

module motor_housing() {
    difference() {
        cube([19, 36, 26], center=true);

        motor_shape(15.2, 32, 20.2);

        rotate([90, 90, 0]) cylinder(h=100, d=12, center=true);

        translate([0, -7, 0]) rotate([0, 0, 90]) motor_shape(10, 32, 22);
    }   

    translate([0, 15, -4]) {
        translate([-12.5, 0, 0]) screw_hole(16);
        translate([12.5, 0, 0]) screw_hole(16);
    }   

    translate([0, -15, -4]) {
        translate([-12.5, 0, 0]) screw_hole(16);
        translate([12.5, 0, 0]) screw_hole(16);
    }
}

module motor_housing_top() {
    difference() {
        motor_housing();
        translate([0, 0, -6.5]) cube([50, 50, 13], center=true);
    }
}

module motor_housing_bottom() {
    difference() {
        motor_housing();
        translate([0, 0, 6.5]) cube([50, 50, 13], center=true);
    }
}

module motor_housing_5v() {
    difference() {
        cube([22, 46, 26], center=true);

        motor_shape(18.6, 40, 24.2);

        rotate([90, 90, 0]) cylinder(h=100, d=12, center=true);

        translate([0, -7, 0]) rotate([0, 0, 90]) motor_shape(10, 32, 22);
    }   

    translate([-7, 20, -9]) {
        translate([-13, 0, 0]) screw_hole(6);
        translate([-7, 0, -1]) cube([6, 6, 6], center=true);
        translate([27, 0, 0]) screw_hole(6);
        translate([21, 0, -1]) cube([6, 6, 6], center=true);
    }   

    translate([-7, -20, -9]) {
        translate([-13, 0, 0]) screw_hole(6);
        translate([-7, 0, -1]) cube([6, 6, 6], center=true);
        translate([21, 0, -1]) cube([6, 6, 6], center=true);
        translate([27, 0, 0]) screw_hole(6);
    }
}

module motor_housing_5v_top() {
    difference() {
        motor_housing_5v();
        translate([0, 0, -23]) cube([50, 50, 26], center=true);
        translate([0, 0, -10]) cube([18.6, 40, 24.2], center=true);
    }
}

module motor_housing_5v_bottom() {
    difference() {
        motor_housing_5v();
        translate([0, 0, 3]) cube([50, 50, 26], center=true);
    }
}

module car_body() {
    union() {
        cube([144, 74, 4], center=true);

        for(x = [1:8:140]) {
            for(y = [1:8:70]) {
                translate([69 - x, 33 - y, 1]) {
                    m3_nut();
                    cylinder(d=3.2, h=100, center=true);
                }

                translate([69 - x, 33 - y, 1]) {
                    m3_nut();
                    cylinder(d=3.2, h=100, center=true);
                }
            }
        }
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

module servo_mount_attachment() {
    difference() {
        translate([0, 0, 10]) cube([6, 26, 30], center=true);
        translate([0, -5, 20]) rotate([90, 0, 90]) cylinder(d=3.2, h=6, center=true);
        translate([0, 5, 20]) rotate([90, 0, 90]) cylinder(d=3.2, h=6, center=true);
    }
    
    translate([0, 16, -2.5]) screw_hole(h=3);
    translate([0, -16, -2.5]) screw_hole(h=3);
}

module wheel_mount_attachment() {
    difference() {
        cube([5, 24, 26], center=true);
        translate([0, -.5, 0]) rotate([90, 0, 90]) cylinder(d=12, h=7, center=true);
    }
    
    translate([0, 15.5, -9.5]) screw_hole(h=5, width=5);
    translate([0, 12.5, -10.5]) cube([5, 1, 5], center=true);
    translate([0, -16.5, -9.5]) screw_hole(h=5, width=5);
    translate([0, -13, -10.5]) cube([5, 2, 5], center=true);
}

wheel_diameter = 30;
wheel_thickness = 4;

shaft_length = 80;
shaft_thickness = 4;

gear_diameter = 22;
gear_height = 4;

motor_gear_diameter = 6;

//front_axel();


//translate([0, 0, -10]) color("green") car_body();



//translate([35.5, 32, 10]) rotate([0, 0, 90]) wheel_mount_attachment();
//translate([-68, 0, 0]) servo_mount_attachment();

//translate([12.5, 4, 10]) motor_housing_bottom();
//translate([12.5, 4, 10]) motor_housing_top();

//translate([16, -4, 10]) motor_housing_5v_bottom();
//translate([16, -4, 11]) motor_housing_5v_top();

//translate([26, 24, 10]) gear_housing(gear_diameter = gear_diameter, gear_height = gear_height, shaft_thickness = shaft_thickness, motor_gear_diameter = motor_gear_diameter);


//servo_mount_gear(height = 5.4, shaft_thickness = shaft_thickness);
//servo_mount();

//translate([0, 0, -10]) servo_mount_top();

motor_attached_gear(height = gear_height - .5);
//motor_peg_attached_gear(height = gear_height - .5);

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

