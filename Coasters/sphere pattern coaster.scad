sphere_spacing = 10;
sphere_spacing_z = 4;

sphere_size = 12;
sphere_size_falloff = 2; // [0:20]

depth = 6;
depth_offset = 14;

$fn = 60;

difference() {
	translate([sphere_spacing/2, 0, -(depth - 4) - depth_offset]) cube([40, 40, depth], center = false);
	for(i = [0:5]) {
		translate([(i % 2) * sphere_spacing/2, (i % 2) * sphere_spacing/2, i * (-sphere_spacing_z)]) {
			level(sphere_size - i * sphere_size_falloff);
		}
	}
}

translate([100, 0, 0]) {
	difference() {
		translate([sphere_spacing/2, 0, -(depth - 4) - depth_offset]) translate([20, 20, 0]) cylinder(d = 40, h = depth, center = false);
		for(i = [0:5]) {
			translate([(i % 2) * sphere_spacing/2, (i % 2) * sphere_spacing/2, i * (-sphere_spacing_z)]) {
				level(sphere_size - i * sphere_size_falloff);
			}
		}
	}
}

module level(sphere_d) {
	array([0:5], [sphere_spacing, 0, 0]) {
		array([0:5], [0, sphere_spacing, 0]) {
			sphere(d = sphere_d);
		}
	}
}

module array(range = [0:1], spacing = [1, 0, 0]) {
	for(i = range) {
		translate(i * spacing) {
			children();
		}
	}
}