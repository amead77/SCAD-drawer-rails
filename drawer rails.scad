/*
drawer rails bracket
*/
$fn = 64;
rail_type ="Vadania 350mm Type 1"; //["Vadania 350mm Type 1]



module peg(od = 4, h = 5) {
    translate([0, 0, h/2]) {
        cylinder(d = od, h = h, center = true);
    }
}

module bracket(
    rail_len_X = 300, 
    bracket_h_Z = 4, 
    bracket_d_Y = 20, 
    bracket_hole_d = 4,
    bracket_hole_offset_X = 20,
    bracket_hole_count = 5
    ) {
    difference() {
        cube([rail_len_X, bracket_d_Y, bracket_h_Z], center = false);

        for (i = [0:bracket_hole_count-1]) {
            translate([
                bracket_hole_offset_X + i*(rail_len_X - 2*bracket_hole_offset_X)/(bracket_hole_count-1), 
                bracket_d_Y/2, 
                bracket_h_Z/2
            ]) {
                cylinder(d = bracket_hole_d, h = bracket_h_Z+0.01, center = true);
            }
        }
    }

}

module rail_side(
    side = "left", 
    rail_len_X = 300, 
    rail_h_Z = 40, 
    rail_d_Y = 4,
    bracket_h_Z = 4,
    bracket_d_Y = 20,
    bracket_hole_d = 4,
    bracket_hole_offset_X = 20,
    bracket_hole_count = 5
    ) {
    cube([rail_len_X, rail_d_Y, rail_h_Z], center = false);
    if (side =="left") {
        translate([0, rail_d_Y, (rail_h_Z-bracket_h_Z)]) {
            bracket(
                rail_len_X = rail_len_X, 
                bracket_h_Z = bracket_h_Z, 
                bracket_d_Y = bracket_d_Y, 
                bracket_hole_d = bracket_hole_d,
                bracket_hole_offset_X = bracket_hole_offset_X,
                bracket_hole_count = bracket_hole_count
            );
        }
    } else { //right side
        //translate([])
    }
}

//peg();
rail_side("left", rail_len_X = 350);