use <threads.scad>

module hex_box(diameter=40, lid_height=10, thread_height=4, container_height=30, wall_thickness=2) {
    thread_diameter = diameter * 0.8;

    difference() {
        // container exterior
        union() {
            translate([
                0, 0, container_height
            ]) ScrewThread(outer_diam=thread_diameter, height=thread_height, tooth_angle=70, pitch=3);
            cylinder(d=diameter, h=container_height, $fn=6);
        }

        // container interior chamber
        d = diameter - (wall_thickness * 2);
        h = container_height - (wall_thickness * 2);
        translate([0, 0, wall_thickness]) cylinder(d=d, h=h*0.9, $fn=6);      


        // hole through the threads on the container
        d2 = thread_diameter * 0.9;
        h2 = thread_height + wall_thickness;
        offset = container_height - wall_thickness;
        translate([0, 0, offset]) cylinder(d=d2, h=h2, $fn = 100);
        
        translate([0, 0, h*0.9 + wall_thickness]) cylinder(d1=d, d2=d2*(2 / sqrt(3)), h=h*0.1, $fn=6);      
    }

    lid_th = lid_height - wall_thickness;

    // container lid
    translate([diameter + wall_thickness*2,0,lid_height]) rotate([0, 180, 0]) {
        ScrewHole(outer_diam=thread_diameter, height=lid_th, tooth_angle=70, pitch=3) {
            cylinder(d=diameter, h=lid_height, $fn = 6);
        }
    }
}

hex_box(diameter=120, lid_height=20, thread_height=8, container_height=80, wall_thickness=2);