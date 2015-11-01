use <endcover.scad>
include <MCAD/constants.scad>

xSpacing = 100;
ySpacing = 180;
textSize = 30;
rowLen = 10;
typeCount = 110;

end_width = 9.25 * mm_per_inch;
end_height = 3*mm_per_inch;

for(type = [0:rowLen:typeCount - 1]) {
	translate([0,0, (type / rowLen) * (ySpacing + end_height)]) {
		row(range=[type:type+rowLen-1]);
	}
}

module row(range = [0:10]) {
	for(type = range) {
		if(type < typeCount) {
			translate([0, (xSpacing+end_width+(textSize*2.5)) * (type - range[0]), 0]) {
				rotate([90,0,90]) linear_extrude(height=1) text(text=str(type+1), size = textSize, font="Liberation Sans");
				translate([0, textSize * 2.5, 0]) rotate([0,90,0]) end_cover(type+1);
			}
		}
	}
}
