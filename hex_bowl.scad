h = 50;
d1 = 60;
d2 = 120;
padding = 2;

difference() {
    cylinder(h=h, d1=d1, d2=d2, $fn=6);
    translate([0, 0, padding]) cylinder(h=h, d1=d1 - padding*2, d2=d2 - padding*2, $fn=6);
}