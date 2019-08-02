// acts on a 2D shape to extrude to a specified offset level (essentially a rough implementation of https://github.com/openscad/openscad/issues/2077 that does not make smooth faces, which should(?) be ok for 3d printing as long as the slice resolution is smaller than your layer height)
module offset_extrude(height, r, delta, chamfer, invert = false, slices = 10) {
	sliceHeight = height / slices;
	
	for(s = [0:sliceHeight:height]) {
		sliceNumber = height / s;
		sliceR = r / sliceNumber;
		sliceDelta = delta / sliceNumber;
		translate([0, 0, invert ? -s : s]) {
			linear_extrude(height = sliceHeight, center = false)
				offset(sliceR, delta = sliceDelta, chamfer=chamfer)
					children();
		}
	}
}