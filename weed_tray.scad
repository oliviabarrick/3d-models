$fn = 100;
eps = 0.01;

thickness = 1;
padding = 10;

grinder_diameter = 55;

scale_width=65;
scale_depth=122;

module ring(x=0, y=0, z=0, h=2, d, d1, d2, thickness=thickness) {
    difference() {
        translate([x, y, z]) cylinder(h=h, d=d, d1=d1, d2=d2);
        translate([x, y, z-eps])
        cylinder(h  = h + eps * 2,
                 d  = d ? d-thickness : d,
                 d1 = d1 ? d1-thickness : d1,
                 d2 = d2 ? d2-thickness : d2);
    }
    
    if (d) {
        cylinder(h = 1, d = d / 5);
    }
}

module tray(width=0, depth=0, height=0, thickness=thickness, rounded_radius=2) {
    difference() {
        minkowski() {
            cube([width, depth, height], center=true);
            cylinder(r=rounded_radius, h=height);
        }
        
        minkowski() {
            translate([0, 0, thickness]) cube([
                width - thickness, depth - thickness, height
            ], center=true);
            cylinder(r=rounded_radius, height);
        }
    }
}

module tool_holder() { 
    difference() {
        cube([ padding * 5, padding, padding ], center = true);

        translate([ padding, 0, 1 ]) cylinder(h=10, d=5);
        translate([ padding * 2, 0, 1 ]) cylinder(h=10, d=5);
        translate([ -padding, 0, 1 ]) cylinder(h=10, d=5);
        translate([ -padding*2, 0, 1 ]) cylinder(h=10, d=5);
    }
}

tray_width = scale_width * 2 + 2 * padding;
tray_depth = scale_depth + 2 * padding;

tray(width=tray_width, depth=tray_depth, height=10, thickness=4);
translate([
    (tray_width / 2) - padding - (scale_width / 2), 0, 2
]) tray(width=scale_width, depth=scale_depth, height=12);

translate([
    -(tray_width / 2) + padding + grinder_diameter / 2, 
    -(tray_depth / 2) + padding + grinder_diameter / 2, 0
]) ring(h=12, d=grinder_diameter);

translate([
    -(tray_width / 2) + padding + (grinder_diameter / 2), 
    (tray_depth / 2) - padding - (grinder_diameter / 2), 0
]) ring(h=12, d=grinder_diameter);


translate([-tray_width / 2 + padding/2, 0, 0]) rotate(90) tool_holder();

// teeth for keks
for (i = [0:4]) {
    translate([
        (tray_width / 2) - padding - (scale_width / 2), (-padding -4) * i, 2
    ]) cube([ scale_width + 4, padding, 1 ], center = true);
}

for (i = [0:4]) {
    translate([
        (tray_width / 2) - padding - (scale_width / 2), (padding + 4) * i, 2
    ]) cube([ scale_width + 4, padding, 1 ], center = true);
}