$fn = 100;

function deg2rad(deg) = deg * 3.14 / 180;

module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size) {
    dihedral = 116.565;
    intersection(){
        box(size);
        intersection_for(i=[1:5])  { 
           rotate([dihedral, 0, 360 / 5 * i]) box(size); 
        }
    }
}

module bead_connector(x=0, y=0, z=0) {
    difference() {
        union() {
            // connector
            translate([x, y, z + 4]) cylinder(h=5, d=1.5);
            translate([x, y, z + 8.4]) sphere(d=4.5);
        }

        union() {
            translate([x, y, z+5]) cube([10, 0.5, 15], center=true);    
            translate([x, y, z+5]) cube([0.5, 10, 15], center=true);
        }
    }
}

module bead(x=0, y=0, z=0) {
    bead_connector(x=x, y=y, z=z);

    difference() {
        // main bead
        translate([x, y, z]) children();
        
        // opening for connector
        translate([x, y, z - 3]) sphere(d=5);
    }
}

bead() sphere(d=10);
bead(x=20) cube([10, 10, 10], center=true);
bead(x=40) dodecahedron(10);
bead(x=60) cylinder(10, d=10, center=true);