/*
drawer rails bracket
*/
$fn = 64;
rail_type ="Vadania 350mm Type 1"; //["Vadania 350mm Type 1]



module peg(od = 4, h = 5) {
    rotate([90, 0, 0]) {
        translate([0, 0, h/2]) {
            cylinder(d = od, h = h, center = true);
        }
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

module rail_pegs(
    rail_len_X = 300, 
    rail_h_Z = 40, 
    rail_peg_d = 4, 
    rail_peg_neg_Z = 25, 
    rail_peg_positions_X = [50, 100, 150, 200]
    ) {
    for (i = [0:len(rail_peg_positions_X)-1]) {
        translate([rail_peg_positions_X[i], 0, rail_h_Z - rail_peg_neg_Z]) {
            peg(od = rail_peg_d);
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
    bracket_hole_count = 5,
    rail_peg_neg_Z = 25, //distance from the top of the rail to the centre of the peg hole
    rail_peg_d = 4, //size of the pegs that go into the rail
    rail_peg_positions_X = [50, 100, 150, 200] //positions of the pegs along the rail, from the front edge back
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
        translate([0, -bracket_d_Y, (rail_h_Z-bracket_h_Z)]) {
            bracket(
                rail_len_X = rail_len_X, 
                bracket_h_Z = bracket_h_Z, 
                bracket_d_Y = bracket_d_Y, 
                bracket_hole_d = bracket_hole_d,
                bracket_hole_offset_X = bracket_hole_offset_X,
                bracket_hole_count = bracket_hole_count
            );
        }
    } //left or right
    translate([0, 0, 0]) {
        rail_pegs(
            rail_len_X = rail_len_X, 
            rail_h_Z = rail_h_Z, 
            rail_peg_d = rail_peg_d, 
            rail_peg_neg_Z = rail_peg_neg_Z, 
            rail_peg_positions_X = rail_peg_positions_X
        );
    }
}

//peg();
rail_side("right", rail_len_X = 350);