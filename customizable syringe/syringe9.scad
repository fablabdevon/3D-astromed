// Space Apps Challenge 2015
// Glyn Cowles
// FabLab Exeter

// Parameterised syringe

vol_reqd=5; // volume in cc of dose
v1=vol_reqd*1000; // translate to cu mm
diameter=20; // external diameter of syringe
thickness=2; // of walls
end_h=12; // height of end part where needle is fixed
pyramid_ht=5; // height of end pyramid
plunger_ht=4; // main plunger body height

side_in=(diameter-thickness*2)/2; // side length of inside
side_out=(diameter)/2; // side length of outside


//end_vol=((sqrt(3))/2)*a*a*pyramid_ht; // volume of pyramid part in cu mm
plunger_vol= (3*sqrt(3)/2) *side_in*side_in*plunger_ht; 
v2=v1-plunger_vol; // running total of vol reqd

height=v2/( (3*sqrt(3)/2) *side_in*side_in);

shape=6; // 6 for hexagon 
plunger_hole_d=3; // diametrer of hole in plunger
plunger_rod_ht=height+plunger_ht; // height of push rod


end_d1=5; // nozzle large diam
end_d2=4; //  nozzle small diam
end_hole_d=3; // nozzle hole diam

wing_width=5; // size of wings on base of tube

oring_d=2; // o ring diameter
diam_short=sqrt(3)*(diameter/2); // flat to flat measurement of outside tube
$fn=40; // fragment number (accuracy)


assemble();

//---------------------------------------------
module assemble() { // show all components
    tube();
    translate([0,0,height]) tube_end();
    //translate([-25,25,0]) tube_end(); // uncomment to print top seperately
    translate([diameter+10,0,height-plunger_ht]) plunger2();
    sc=.95; // use this to scale rod in xy direction (set to 1 for normal size)
    translate([diameter+10,0,0]) scale([sc,sc,1]) plunger_rod();
    #translate([-diameter-5,-diameter+20,oring_d/2]) oring(r=(diameter-thickness*2)/2);
}
//---------------------------------------------
module oring(r=10) {
//spiralSimple(height=20,Radius=20,baseRadius=3,frequency=1,resolution=5)
spiralSimple(0,r,.5,4,25);

/*
//circular o ring
rotate_extrude(convexity =10)
translate([diameter/2-thickness, 0, 0])
circle(r = oring_d/2);
*/

}
//---------------------------------------------
module tube() { // main tube
difference() {
    union(){
    cylinder(h=height,d=diameter,$fn=shape);
    translate([-side_in/2,diam_short/2,0])cube([side_in,wing_width,thickness]); // wing 1
    translate([-side_in/2,-diam_short/2-wing_width,0]) cube([side_in,wing_width,thickness]); // wing 2
    //cylinder(h=thickness,d=diameter+6,$fn=shape);   
    } 
    translate([0,0,0]) cylinder(h=height,d=diameter-(thickness*2),$fn=shape); // hollow it
}
    
}
//---------------------------------------------
module tube_end() { // pyramid & nozzle
    difference() {
        union() {
            cylinder(h=pyramid_ht,d1=diameter,d2=end_d1+1,$fn=shape);
            translate([0,0,pyramid_ht])
                cylinder(h=end_h,d1=end_d1,d2=end_d2);
        }
    
    cylinder(h=pyramid_ht,d1=diameter-(thickness*2),d2=end_d1-(thickness*2),$fn=shape); 
    cylinder(h=end_h*2,d=end_hole_d);
    
}
}
//---------------------------------------------
module plunger() { // rubber plunger (print seperately)
    difference() {
        union() {
        cylinder(d=diameter-thickness*2,h=plunger_ht,$fn=shape);
        translate([0,0,plunger_ht]) cylinder(h=pyramid_ht,d1=diameter-( thickness*2),d2=end_d1-(thickness*2),$fn=shape); 
            }
    cylinder(d=plunger_hole_d,h=plunger_ht); // hole for rod
    translate([0,0,plunger_ht]) cylinder(d=plunger_hole_d+1,2); //slightly wider bit to hold rod in place 2mm high
            
    }
    
}
//---------------------------------------------
module plunger2() { // rubber plunger (print seperately)
    sc=1;
    difference() {
        scale([sc,sc,1])plunger();
        translate([0,0,plunger_ht/2]) oring(r=(diameter-thickness*2)/2);
    }
        
}


//---------------------------------------------
module plunger_rod() { // rod to attach to plunger
    cylinder(d=plunger_hole_d,h=height); 
    translate([0,0,height]) cylinder(d=plunger_hole_d+1,2); // bit that locks in to plunger
    cylinder(h=thickness,d=diameter-(thickness*2),$fn=shape);
    difference() {
    translate([-(diameter-thickness*2)/2,-thickness/2,thickness]) cube([diameter-thickness*2,thickness,height-plunger_ht]);
     translate([0,0,thickness])
        difference(){
        cylinder(h=height-plunger_ht,d=diameter-(thickness*2)+10,$fn=shape);    
        cylinder(h=height-plunger_ht,d=diameter-(thickness*2),$fn=shape);    
        }
    }
}

//---------------------------------------------


//-------------------------------------------------------------
//simple spiral
module spiralSimple(height=20,Radius=20,baseRadius=3,frequency=1,resolution=5) {
	union(){
		translate ([0,0,-(height/2)]) {
				for(i=[0:resolution-2]){
					hull(){
						rotate ([0,0,frequency*360/(resolution-1)*i]) translate ([Radius,0,i*height/(resolution-1)]) sphere(r=baseRadius, center=true);
						rotate ([0,0,frequency*360/(resolution-1)*(i+1)]) translate ([Radius,0,(i+1)*height/(resolution-1)]) sphere(r=baseRadius,center=true);
					}
				}
		}
	}
}