use <poly.scad>
include <MCAD/units.scad>
include <MCAD/constants.scad>

in = mm_per_inch;

polyhedron_type = 16;

//overall size parameters
end_thickness = 7/16*in; //this was the thickness of the original piece I'm basing this on
max_end_thickness = 180; //defines the maximum thickness of the end cap
end_width = 9.25 * in;
end_height = 3*in;
end_curve_height = 10/16 * in; //how much of the height is taken up by the curved portion
fillet_radius = 5/16 * in;

//screw hole parameters
hole_spacing = 3.5 * in; //distance between holes
hole_height = 2*in + 1/16*in; //vertical distance from bottom of end piece to center of holes
hole_dia = 1/8 * in; //diameter of screw holes
hole_depth = 3/8 * in; //depth of screw holes

rotate([0,-90,0]) intersection() {
	end_polyhedron(end_width, end_height, polyhedron_type);

	//the shape of the original end cap that the new one must match
	difference() {
		end_cap(max_end_thickness, end_width, end_height, fillet_radius, end_curve_height);
		//bolt holes
		translate([-0.1, end_width/2, hole_height]) {
			translate([0, -hole_spacing/2, 0]) rotate([0,90,0]) cylinder(d=hole_dia, h=hole_depth + 0.1);
			translate([0, hole_spacing/2, 0]) rotate([0,90,0]) cylinder(d=hole_dia, h=hole_depth + 0.1);
		}
	}
}

module end_polyhedron (width, height, polyType) {
	//shape used for end cap
	translate([0, width / 2, 0]) resize([width, width, height*2]) P(polyType); //the polyhedron
}

module end_cap (end_thickness, end_width, end_height, fillet_radius, end_curve_height) {
	//shape of light end cap
	cube(size=[end_thickness, end_width, end_height - end_curve_height]);
	hull() translate([0, 0, end_height - end_curve_height]) {
		translate([0,fillet_radius,0])rotate([0,90,0]) cylinder(r=fillet_radius, h=end_thickness);
		translate([0,end_width - fillet_radius,0]) rotate([0,90,0]) cylinder(r=fillet_radius, h=end_thickness);
		translate([0,end_width/2, end_curve_height - fillet_radius]) rotate([0,90,0]) cylinder(r=fillet_radius, h=end_thickness);
	}
}