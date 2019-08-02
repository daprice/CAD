use <offset_extrude.scad>

module houseNumbers(characters, charSpacing, thickness, baseOutset, topEdgeChamferSize, ridgeInset, ridgeWidth, color1, color2, fontSize, font, fontStyle) {
	for(c = [0:len(characters)]) {
		$fn = 50;
		translate([c*charSpacing, 0, 0]) {
			bevel_style(thickness, baseOutset, true, topEdgeChamferSize, ridgeInset, ridgeWidth, color1, color1, color2)
				text(characters[c], size=fontSize, font=str(font, ":style=", fontStyle));
		}
	}
}

module bevel_style(thickness, baseOutset, baseChamfer = false, topEdgeChamferSize, ridgeInset, ridgeWidth, baseColor, ridgeColor, topColor) {
	baseThickness = thickness/3;
	baseBevelThickness = thickness/3;
	topThickness = thickness/3;
	topBaseThickness = topThickness - topEdgeChamferSize;
	topBevelThickness = topEdgeChamferSize;
	
	echo("top color change height:", baseThickness + baseBevelThickness);
	
	color(baseColor) {
		// non-beveled base
		linear_extrude(height = baseThickness, center = false)
			offset(delta = baseOutset, chamfer = baseChamfer)
				children();
	
		// beveled portion of base (bevel to normal)
		translate([0,0, baseThickness + baseBevelThickness])
			offset_extrude(height = baseBevelThickness, delta = baseOutset, chamfer = baseChamfer, invert = true)
				children();
	}

	//beveled top portion
	translate([0, 0, baseThickness + baseBevelThickness]) difference() {
		// flat top portion
		color(topColor) {
			linear_extrude(height = topBaseThickness)
				children();
			
			translate([0, 0, topBaseThickness])
				offset_extrude(height = topBevelThickness, delta = -topEdgeChamferSize)
					children();
		}
			
		// inset ridge thing
		color(ridgeColor)
			translate([0, 0, topThickness / 2])
				linear_extrude(height = topThickness) difference() {
					offset(delta = -ridgeInset) children();
					offset(delta = -ridgeInset - ridgeWidth) children();
				}
	}
}