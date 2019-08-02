// This uses fonts from the local system which may not be licensed for distribution in the form of individual characters. Do not share exported STLs or other formats unless allowed to do so by your font license.

baseOutset = 3; // mm
thickness = 7; // mm
topEdgeChamferSize = 1; // mm
ridgeInset = 0; // mm
ridgeWidth = 0; // mm

font = "Benguiat Pro ITC";
fontStyle= "Bold";
fontSize = 75;

characters = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];


charSpacing = fontSize*1.5;

include <MCAD/materials.scad>
include <house numbers.scad>

houseNumbers(characters, charSpacing, thickness, baseOutset, topEdgeChamferSize, ridgeInset, ridgeWidth, Steel, BlackPaint, fontSize, font, fontStyle);