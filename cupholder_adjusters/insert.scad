//Cupholder inserts (customizable)
//	My parents' couch has absurdly deep cupholders. These sit in the bottom and take up space so you don't have to reach way down in there to get your drink out.

diameter = 85;
depth = 20;

notch = 20;

difference()
{
	cylinder(h = depth, r = diameter/2, center = true, $fn = 180);

	//grabby handle
	translate([0,diameter/2-notch/2,0])
	rotate([45,0,0])
	cube([notch,notch*2,depth*10], center=true);
}
