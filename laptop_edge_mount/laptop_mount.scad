// Edge-hanging laptop mount
// by Dale Price
// https://github.com/daprice/CAD & http://www.thingiverse.com/daprice/

/* [Laptop Mounting] */

// depth of laptop stand surface (mm)
depth = 195;
// width of laptop arms (mm)
arm_width = 20;
// size of laptop holding lip
lip = 15;
// thickness of laptop holding lip
lip_thickness = 3;

/* [Structure] */

// angle from wall (degrees)
angle = 50;
// width of stand (mm) (max Z dimension when printing)
width = 75;
// support thickness (mm)
thickness = 8; // [5:30]

arm_spacing = width - arm_width;
rotated_depth = sin(angle) * depth;
rotated_height = cos(angle) * depth;

/* [Edge Attachment] */

// hook depth (mm) (i.e. thickness of wall/fence to be mounted on)
hook_depth = 38;
// vertical size of hook (mm)
hook_vert = 15;
// hook thickness (mm)
hook_thickness = 3;

hook_outer_depth = hook_depth + hook_thickness;


wall_support_pos = -hook_depth-hook_thickness;
wall_support_height = rotated_height-((hook_depth+hook_thickness)/tan(angle));
structural_support_length = tan(angle)*wall_support_height;

rotate([0, -90, 0])
union() {
	translate( [0, 0, rotated_height] )
	rotate( [90-angle, 0, 0] )
	union() {
		for (arm = [0, arm_spacing]) {
			translate( [arm, -depth, 0])
			//arms
			cube( [arm_width, depth, thickness], center = false );
		}
		
		//rear support and hook
		hull() { //should be hull
			//support
			translate([0,-thickness,0])cube( [arm_spacing+arm_width, thickness, thickness], center=false );
			//hook surface
			rotate([-90+angle,0,0])translate([0,-hook_depth-hook_thickness,-(tan(90-angle)*(hook_depth+hook_thickness))])cube( [arm_spacing+arm_width, hook_depth+hook_thickness, thickness/sin(angle)], center=false );
		}
	
		//hooky part of hook
		rotate([-90+angle,0,0])translate([0,-hook_thickness,-(tan(90-angle)*(hook_depth+hook_thickness))-hook_vert])cube( [arm_spacing+arm_width, hook_thickness, hook_vert], center=false );
	
		//front support
		translate([arm_width,-depth-lip_thickness,0])cube( [arm_spacing-arm_width, thickness, thickness], center=false );
	
		//laptop holding lips
		translate([0,-lip_thickness-depth,0])cube( [arm_spacing+arm_width, lip_thickness, lip], center = false);
	}
	
	//wall supports
	for(arm = [0, arm_spacing+(arm_width-thickness)]) {
		translate([arm, wall_support_pos-thickness, 0])
		cube( [thickness, thickness, wall_support_height], center=false );
	}
	
	//in between wall supports
	translate([thickness, wall_support_pos-thickness, 0])
	cube( [width-2*thickness, thickness, thickness], center=false );
	
	//structural supports
	for(arm = [0, arm_spacing+(arm_width-thickness)]) {
		translate([arm, wall_support_pos-structural_support_length, 0])
		cube( [thickness, structural_support_length, thickness], center=false );
	}
}