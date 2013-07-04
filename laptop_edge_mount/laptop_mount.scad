// Edge-hanging laptop mount
// by Dale Price
// https://github.com/daprice/CAD & http://www.thingiverse.com/daprice/

use <utils/build_plate.scad>;

/* [Build plate preview] */
//for display only, doesn't contribute to final object
build_plate_selector = 0; //[0:Replicator 2,1: Replicator,2:Thingomatic,3:Manual]

//when Build Plate Selector is set to "manual" this controls the build plate x dimension
build_plate_manual_x = 100; //[100:400]

//when Build Plate Selector is set to "manual" this controls the build plate y dimension
build_plate_manual_y = 100; //[100:400]

/* [Laptop Mounting] */

// depth of laptop stand surface (mm)
depth = 195; // [100:350]
// width of laptop arms (surface that laptop sits on)
arm_width = 20; // [10:Narrow,20:Medium,30:Wide]
// size of laptop holding lip (mm)
lip = 25; // [15:40]
// thickness of laptop holding lip (mm)
lip_thickness = 3; // [2:Thin,3:Normal,5:Extra Beefy]

/* [Structure] */

// angle (degrees)
angle = 40; // [20:70]
inverseAngle = 90 - angle;
// width of stand (Z dimension when printing; larger = more stable)
width = 75; // [75:fit i2,150:fit Replicator 2,170:fit MendelMax/AO-101 (approx.),240:fit Taz]
// support thickness (mm)
thickness = 10; // [5:25]

arm_spacing = width - arm_width;
rotated_depth = sin(inverseAngle) * depth;
rotated_height = cos(inverseAngle) * depth;

/* [Edge Attachment] */

// Do you want to mount your laptop on an edge or stand it on a surface
edge_mount = 1; // [1:Edge mount,0:Surface stand]
// hook depth (mm) (i.e. thickness of wall/fence/rail to be mounted on)
hook_depth_ = 38; // [10:45]
// vertical size of hook (mm)
hook_vert_ = 15; // [5:25]
// hook thickness (mm)
hook_thickness_ = 3; // [2:Wimpy Wimpy Wimpy,3:Normal,6:Double Meat]

//zero out hook sizes if edge_mount is false
hook_depth = hook_depth_ * edge_mount;
hook_vert = hook_vert_ * edge_mount;
hook_thickness = hook_thickness_ * edge_mount;

hook_outer_depth = hook_depth + hook_thickness;


wall_support_pos = -hook_depth-hook_thickness;
wall_support_height = rotated_height-((hook_depth+hook_thickness)/tan(inverseAngle));
structural_support_length = tan(inverseAngle)*wall_support_height;

rotate([0,0,-90])
translate([.5*rotated_height, .5*rotated_depth+0.5*(sin(inverseAngle)*lip), 0])
rotate([0, -90, 0])
union() {
	translate( [0, 0, rotated_height] )
	rotate( [90-inverseAngle, 0, 0] )
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
			rotate([-90+inverseAngle,0,0])translate([0,-hook_depth-hook_thickness,-(tan(90-inverseAngle)*(hook_depth+hook_thickness))])cube( [arm_spacing+arm_width, hook_depth+hook_thickness, thickness/sin(inverseAngle)], center=false );
		}
	
		//hooky part of hook
		rotate([-90+inverseAngle,0,0])translate([0,-hook_thickness,-(tan(90-inverseAngle)*(hook_depth+hook_thickness))-hook_vert])cube( [arm_spacing+arm_width, hook_thickness, hook_vert], center=false );
	
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

build_plate(build_plate_selector,build_plate_manual_x,build_plate_manual_y);