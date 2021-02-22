include <MCAD/units.scad>
include <MCAD/constants.scad>

gear_depth = 0.25 * inch;
gear_teeth = 12;
gear_major_d = (3/8) * inch - (1/16) * inch;
gear_minor_d = (3/8) * inch - (2/16) * inch;

knob_depth = 2 * inch;
knob_cutout_d = 1.5 * inch;

screw_dia = (3/16) * inch;

module gear_profile(minor_d, major_d, tooth_count) {
	gear_major_circumference = PI * gear_major_d;
	gear_tooth_width = gear_major_circumference / gear_teeth / 2;
	
	$fs = 0.1;
	
	union() {
		circle(d = gear_minor_d);
		intersection() {
			circle(d = gear_major_d);
			for(angle = [0 : 360/12 : 360]) {
				rotate([0, 0, angle])
					square([gear_tooth_width, gear_major_d], center = true);
			}
		}
	}
}

module gear(minor_d, major_d, tooth_count, depth) {
	linear_extrude(height = depth, center = false) gear_profile(minor_d, major_d, tooth_count);
}

module knob_profile(max_d, min_d) {
	
	difference() {
		circle(d = max_d);
		for(angle = [0 : 360/3 : 360]) {
			rotate([0, 0, angle]) translate([0, max_d, 0]) {
				circle(d = max_d + (max_d - min_d));
			}
		}
	}
}

module knob_shell() {
	knob_min_d = 2 * inch;
	knob_max_d = 3 * inch;
	
	intersection() {
		$fn = 180;
		linear_extrude(height = knob_depth, center = false) knob_profile(knob_max_d, knob_min_d);
		translate([0, 0, knob_depth]) sphere(r = knob_depth + 0.15 * inch);
	}
}

module knob(depth, screw_d, cutout_d, gear_minor_d, gear_major_d, gear_tooth_count, gear_depth) {
	screw_wall_thickness = 2;
	
	difference() {
		knob_shell();
		translate([0, 0, 0]) {
			cylinder(h = depth, d = screw_d);
			
			translate([0, 0, screw_wall_thickness]) {
				gear(gear_minor_d, gear_major_d, gear_tooth_count, gear_depth);
				
				translate([0, 0, depth]) {
					cylinder(d = cutout_d, h = depth);
				}
			}
		}
	}
}

module knob_test() {
	intersection() {
		knob(knob_depth, screw_dia, knob_cutout_d, gear_minor_d, gear_major_d, gear_teeth, gear_depth);
		cylinder(d = 15, h = 2 + gear_depth);
	}
}

knob(knob_depth, screw_dia, knob_cutout_d, gear_minor_d, gear_major_d, gear_teeth, gear_depth);