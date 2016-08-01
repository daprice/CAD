// inner diameter of bearing, should match the shaft diameter + ~1mm
id = 9;

// outer diameter of bearing
od = 24;

// number of balls in bearing
num_balls = 5; // [3:1:20]

// diameter of balls in bearing
ball_d = 5;

// extra space allowed around each ball
ball_tol = 0.9; // [0:0.05:2]

// thickness of ball cage
cage_thick = 3.5;


difference() {
	//generate shape of bearing cage
	cylinder(h=cage_thick, d = od, center = true);
	cylinder(h=cage_thick+1, d = id, center=true);
	
	ball_angle = 360 / num_balls;

	for(ball = [0 : 1 : num_balls]) {
		rotate([0, 0, ball * ball_angle]) {
			translate([(id + (od - id)/2) / 2, 0, 0]) {
				//holes for balls
				sphere(d=ball_d + ball_tol, center=true, $fn = 40);
				
				//preview of balls in bearing
				%sphere(d=ball_d, center=true, $fn=40);
			}
		}
	}
}
