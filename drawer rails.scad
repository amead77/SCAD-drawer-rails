/*
drawer rails bracket
*/
$fn = 64;
rail_type ="Vadania 350mm Type 1"; //["Vadania 350mm Type 1"]
side = "left"; //["left", "right"]

//set up default values, customiser can mod these.
rail_len_X_default = 300;
rail_h_Z_default = 30;
rail_d_Y_default = 4;
bracket_h_Z_default = 4;
bracket_d_Y_default = 20;
bracket_hole_d_default = 5.2;
bracket_hole_offset_X_default = 20;
bracket_hole_count_default = 5;
rail_peg_neg_Z_default = 25;
rail_peg_d_default = 6;
rail_peg_positions_X_default = [34.75, 98.75, 162.75, 258.75];
rail_peg_len_Y_default = 5.5;
reinforcing_positions_X_default = [0, 60, 120, 180, 240, 296];
reinforcing_thickness_X_default = 4;

debug_chop = false; //[true, false]
debug_chop_size = [400, 30, 40];
debug_chop_offset = [0, 2, 0];

// Profile index map:
// 0 rail_len_X, 1 rail_h_Z, 2 rail_d_Y, 3 bracket_h_Z, 4 bracket_d_Y,
// 5 bracket_hole_d, 6 bracket_hole_offset_X, 7 bracket_hole_count,
// 8 rail_peg_neg_Z, 9 rail_peg_d, 10 rail_peg_positions_X,
// 11 rail_peg_len_Y, 12 reinforcing_positions_X, 13 reinforcing_thickness_X.
profile_default = [
    rail_len_X_default,
    rail_h_Z_default,
    rail_d_Y_default,
    bracket_h_Z_default,
    bracket_d_Y_default,
    bracket_hole_d_default,
    bracket_hole_offset_X_default,
    bracket_hole_count_default,
    rail_peg_neg_Z_default,
    rail_peg_d_default,
    rail_peg_positions_X_default,
    rail_peg_len_Y_default,
    reinforcing_positions_X_default,
    reinforcing_thickness_X_default
];


//to add new profiles, add a new array block like the below and 
//add to the ternary operator below it
profile_vadania_350_type_1 = [
    300, //rail_len_X
    30, //rail_h_Z
    5, //rail_d_Y - the rail part of bracket thickness
    4, //bracket_h_Z - the bracket top thickness
    20, //bracket_d_Y - the screw hole diameter for the bracket under desl support
    5.5, //bracket_hole_d
    20, //bracket_hole_offset_X
    5, //bracket_hole_count
    25, //rail_peg_neg_Z - the position of the rail pegs from the top of the rail bracket
    6, //rail_peg_d - peg diameter
    [34.75, 98.75, 162.75, 258.75], //rail_peg_positions_X
    3.5, //rail_peg_len_Y - how long the pegs are
    [0, 60, 120, 180, 240, 296], //reinforcing_positions_X
    4 //reinforcing_thickness_X
];

selected_profile = (rail_type == "Vadania 350mm Type 1")
    ? profile_vadania_350_type_1
    : profile_default;

//end of profile setup, start of main code



rail_len_X = selected_profile[0];
rail_h_Z = selected_profile[1];
rail_d_Y = selected_profile[2];
bracket_h_Z = selected_profile[3];
bracket_d_Y = selected_profile[4];
bracket_hole_d = selected_profile[5];
bracket_hole_offset_X = selected_profile[6];
bracket_hole_count = selected_profile[7];
rail_peg_neg_Z = selected_profile[8];
rail_peg_d = selected_profile[9];
rail_peg_positions_X = selected_profile[10];
rail_peg_len_Y = selected_profile[11];
reinforcing_positions_X = selected_profile[12];
reinforcing_thickness_X = selected_profile[13];




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

module reinforcing_bracket(
    positions_X = [0, 100, 200, 250],
    thickness_X = 4,
    rail_h_Z = 40,
    bracket_d_Y = 20
    ) {
    for (x_pos = positions_X) {
        translate([x_pos, 0, 0]) {
            polyhedron(
                points = [
                    [0, 0, 0],
                    [0, 0, rail_h_Z],
                    [0, bracket_d_Y, rail_h_Z],
                    [thickness_X, 0, 0],
                    [thickness_X, 0, rail_h_Z],
                    [thickness_X, bracket_d_Y, rail_h_Z]
                ],
                faces = [
                    [0, 1, 2],
                    [3, 5, 4],
                    [0, 3, 4, 1],
                    [1, 4, 5, 2],
                    [0, 2, 5, 3]
                ]
            );
        }
    }
}

module rail_pegs(
    rail_len_X = 300, 
    rail_h_Z = 40, 
    rail_peg_d = 4, 
    rail_peg_neg_Z = 25, 
    rail_peg_positions_X = [50, 100, 150, 200],
    rail_peg_len_Y = 10
    ) {
    for (i = [0:len(rail_peg_positions_X)-1]) {
        translate([rail_peg_positions_X[i], 0, rail_h_Z - rail_peg_neg_Z]) {
            peg(od = rail_peg_d, h = rail_peg_len_Y);
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
    rail_peg_positions_X = [50, 100, 150, 200], //positions of the pegs along the rail, from the front edge back
    rail_peg_len_Y = 10, //length of the pegs that go into the rail
    reinforcing_positions_X = [0, 100, 200, 250],
    reinforcing_thickness_X = 4
    ) {
    union() {
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
            translate([0, 0, 0]) {
                rail_pegs(
                    rail_len_X = rail_len_X, 
                    rail_h_Z = rail_h_Z, 
                    rail_peg_d = rail_peg_d, 
                    rail_peg_neg_Z = rail_peg_neg_Z, 
                    rail_peg_positions_X = rail_peg_positions_X,
                    rail_peg_len_Y = rail_peg_len_Y
                );
            }
            translate([0, rail_d_Y, 0]) {
                reinforcing_bracket(
                    positions_X = reinforcing_positions_X,
                    thickness_X = reinforcing_thickness_X,
                    rail_h_Z = rail_h_Z,
                    bracket_d_Y = bracket_d_Y
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
            translate([0, rail_d_Y+rail_peg_len_Y, 0]) {
                rail_pegs(
                    rail_len_X = rail_len_X, 
                    rail_h_Z = rail_h_Z, 
                    rail_peg_d = rail_peg_d, 
                    rail_peg_neg_Z = rail_peg_neg_Z, 
                    rail_peg_positions_X = rail_peg_positions_X,
                    rail_peg_len_Y = rail_peg_len_Y
                );
            }
            scale([1, -1, 1]) {
                reinforcing_bracket(
                    positions_X = reinforcing_positions_X,
                    thickness_X = reinforcing_thickness_X,
                    rail_h_Z = rail_h_Z,
                    bracket_d_Y = bracket_d_Y
                );
            }
        } //left or right
    }
}
render() {
    difference() {
        rail_side(
            side = side, 
            rail_len_X = rail_len_X, 
            rail_h_Z = rail_h_Z, 
            rail_d_Y = rail_d_Y, 
            bracket_h_Z = bracket_h_Z, 
            bracket_d_Y = bracket_d_Y, 
            bracket_hole_d = bracket_hole_d, 
            bracket_hole_offset_X = bracket_hole_offset_X, 
            bracket_hole_count = bracket_hole_count, 
            rail_peg_neg_Z = rail_peg_neg_Z, 
            rail_peg_d = rail_peg_d, 
            rail_peg_positions_X = rail_peg_positions_X, 
            rail_peg_len_Y = rail_peg_len_Y,
            reinforcing_positions_X = reinforcing_positions_X,
            reinforcing_thickness_X = reinforcing_thickness_X
        );

        if (debug_chop) {
            translate(debug_chop_offset) {
                %cube(debug_chop_size, center = false);
            }
        }

    }
}