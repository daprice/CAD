//Socket wrench (customizable)

// size of drive 1
drive1 = 6.35;
// size of drive 2
drive2 = 12.7;
// drive size tolerance
tolerance = 0.2;

tolDrive1 = drive1 - tolerance;
tolDrive2 = drive2 - tolerance;

D = 15;
// MARGIN	
M = D/2; 	
// HEIGHT (THICKNESS) OF TOOL in mm
H = 10;
// TOTAL LENGTH OF TOOL in mm
Ltot = 150; 	

// Length from Center of One Side to Center of Other Side
L = Ltot-2*(D/2+M);
union()
{
	//Jamesdavid's parametric wrench
	difference() {
		union() {
			translate([0,L/2,H/2]) {
				cylinder(r = (D/2+M), h = H,center = true);
			}
			translate([0,-L/2,H/2]) {
				cylinder(r = (D/2+M), h = H,center = true);
			}
			translate([-1*D/2,-L/2,0]) {
				cube([D,L,H], center=false);
			}
		}
	}
	
	//socket drives
	translate([0, L/2, H+(tolDrive1/2)])
	cube(size = tolDrive1, center = true);

	translate([0, -L/2, H+(tolDrive2/2)])
	cube(size = tolDrive2, center = true);
}