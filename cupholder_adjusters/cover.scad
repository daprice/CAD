//Cupholder covers
//	Covers for couch cupholders so my dog will stop tripping in them when she climbs on the couch.

cupholder_diameter = 85;
cover_diameter = 110;

cover_thickness = 10;

insert_depth = 20;
insert_thickness = 2;

union()
{
	cylinder(h=cover_thickness, r=cover_diameter/2, center = true, $fn = 180);

	translate([0,0,cover_thickness/2 + insert_depth/2 - 0.01])
	difference()
	{
		cylinder(h = insert_depth, r = cupholder_diameter/2, center = true, $fn = 180);
		cylinder(h = insert_depth + 0.01, r = cupholder_diameter/2 - insert_thickness, center=true, $fn=180); 
	}
}
