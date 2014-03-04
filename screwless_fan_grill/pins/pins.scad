// PLA Pin Connectors
// WHPThomas <me@henri.net>
// Derived to provide a drop in replacement for Tony Buser's pin connectors <tbuser@gmail.com>

//pinhole(h=12, tight=false);
//test();
//pintack(h=20);
//pinpeg(h=24);

module test() {
  tolerance = 0.2;
  radius=7/2;
  
  translate([-12, 16, 0]) pinpeg(h=21, r=radius);
  translate([12, 12, 0]) pintack(h=12, r=radius);
  
  difference() {
    union() {
      translate([0, -12, 2.5]) cube(size = [60, 20, 5], center = true);
      translate([24, -12, 7.5]) cube(size = [12, 20, 15], center = true);
    }
    translate([-24, -12, 0]) pinhole(h=5, r=radius, t=tolerance);
    translate([-12, -12, 0]) pinhole(h=5, r=radius, t=tolerance, tight=false);
    translate([0, -12, 0]) pinhole(h=16, r=radius, t=tolerance);
    translate([12, -12, 0]) pinhole(h=16, r=radius, t=tolerance, tight=false);
    translate([24, -12, 15]) rotate([0, 180, 0]) pinhole(h=12, r=radius, t=tolerance);
  }
}

module pinhole(h=16, r=4, lh=3, lt=1, t=0.3, tight=true) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  // t = tolerance
  // tight = set to false if you want a joint that spins easily
  union() {
    pin_solid(h, r+(t/2), lh, lt);
    if (tight) {
      // make the cylinder slightly longer
      cylinder(h=h+t, r=r, $fn=30);
    }
    else {
      // make the cylinder slightly longer and wider
      cylinder(h=h+t, r=r+(t/2)+t, $fn=30);
    }
    // camfer the entrance hole to make insertion easier
    translate([0, 0, -0.1]) cylinder(h=lh/3, r2=r, r1=r+(t/2)+(lt/2), $fn=30);
  }
}

module pin(h=16, r=4, lh=3, lt=1, side=false) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  // side = set to true if you want it printed horizontally
  //hh = h < 2.5*r ? 2.5*r : h;
  hh = h;
  //if(h < 2.5*r) echo("****** WARNING: pin caped at minimum length ", h, "set to", hh);

  if (side) {
    pin_horizontal(hh, r, lh, lt);
  } else {
    pin_vertical(hh, r, lh, lt);
  }
}

module pintack(h=16, r=4, lh=3, lt=1, bh=3, br=8.75) {
  // bh = base_height
  // br = base_radius
  
  union() {
    cylinder(h=bh, r=br);
    translate([0, 0, bh]) pin(h, r, lh, lt);
  }
}

module pinpeg(h=32, r=4, lh=3, lt=1, t=0.1, tabs=false) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  // t = tolerance
  hh = h < 6*r ? 6*r : h;
  if(h < 6*r) echo("****** WARNING: pinpeg caped at minimum length ", h, "set to", hh);
  union() {
    translate([0, -hh/4+t/2, 0]) pin_horizontal(hh/2+t, r, lh, lt);
    translate([0, hh/4-t/2, 0]) rotate([0, 0, 180]) pin_horizontal(hh/2+t, r, lh, lt);
	if(tabs) {
		translate([0, hh*3/8, 0]) cylinder(h=0.15, r=2*r);
		translate([0, -hh*3/8, 0]) cylinder(h=0.15, r=2*r);
	}
  }
}

// just call pin instead, I made this module because it was easier to do the rotation option this way
// since openscad complains of recursion if I did it all in one module
module pin_vertical(h=16, r=4, lh=3, lt=1) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  cl=r*2.1;
  cz=h-(r*2);
  difference() {
    pin_solid(h, r, lh, lt, false);
    
    // center cut
    translate([-r*0.5/2, -(r*2+lt*2)/2, cz]) cube([r*0.5, r*2+lt*2, cl]);
    translate([0, 0, cz]) 
    scale(v=[1,r/(r+lt)*1.05,1]){
       sphere(r=r*1/2, $fn=20);
       cylinder(h=cl, r1=r*1/2, r2=r*4/5, $fn=20);
    }
    // center curve
    translate([0, 0, cz]) rotate([90, 0, 0]) cylinder(h=cl, r=r/4, center=true, $fn=20);
  
    // side cuts
    translate([-r*2, -lt-r*1.125, -1]) cube([r*4, lt*2, h+2]);
    translate([-r*2, -lt+r*1.125, -1]) cube([r*4, lt*2, h+2]);
  }
}

// call pin with side=true instead of this
module pin_horizontal(h=16, r=4, lh=3, lt=1) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  translate([0, h/2, r*1.125-lt]) rotate([90, 0, 0]) pin_vertical(h, r, lh, lt);
}

// this is mainly to make the pinhole module easier
module pin_solid(h=16, r=4, lh=3, lt=1, hole=true) {
  union() {
    // shaft
    cylinder(h=h-(lh/2), r=r, $fn=30);
    // lip
    if(hole) {
      translate([0, 0, h-lh]) cylinder(h=lh*0.25, r1=r, r2=r+lt, $fn=30);
      translate([0, 0, h-lh+lh*0.25]) cylinder(h=lh*0.25, r=r+lt, $fn=30);    
      translate([0, 0, h-lh+lh*0.5]) cylinder(h=lh*0.5, r1=r+lt, r2=r, $fn=30);
    }
    else {
      scale(v=[1,r/(r+lt)*1.05,1]) {
        translate([0, 0, h-lh]) cylinder(h=lh*0.25, r1=r, r2=r+(lt*2/3), $fn=30);
        translate([0, 0, h-lh+lh*0.25]) cylinder(h=lh*0.25, r=r+(lt*2/3), $fn=30);    
        translate([0, 0, h-lh+lh*0.50]) cylinder(h=lh*0.50, r1=r+(lt*2/3), r2=r-(lt/2), $fn=30);
      }
    }
  }
}
