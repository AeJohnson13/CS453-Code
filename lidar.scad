// Lidar spinner

$fa = 5;
$fs = 0.3;

//stepper dimensions
clearance = 0.14;
stepperHeight = 20 + clearance;
stepperWidth = 40 + 12 * clearance;

stepperRodHeight = 25 + clearance;
stepperRodDiamter = 5 + clearance;


stepperCableWidth = 15 + 12 *clearance;
stepperCableHeight = stepperHeight;
stepperCableDepth = 100 + 4* clearance;  // can exagerate to leave larger cutout 

module stepper(){
    union(){
        
        // Stepper Base
        translate([0, 0, -stepperHeight/2]){
            cube([stepperWidth, stepperWidth, stepperHeight], center = true);
        } 
        
        // Stepper Rod
        translate([0,0,stepperRodHeight/2]){
            difference(){
                cylinder(h = stepperRodHeight, r = stepperRodDiamter/2, center = true);
                translate([-3.5,0,0.1]){
                    cube([3, 3, stepperRodHeight], center=true);
                } 
        } 
    }
        // Stepper Cabling
        translate([stepperWidth/2+ stepperCableDepth/2,0,stepperCableHeight/2-stepperHeight]){
            cube([stepperCableDepth,stepperCableWidth, stepperCableHeight], center = true);
        } 
    }
} 

// dimensions for lidar base 

baseThickness = 4.74 * 3; // should be exactly 24 lines
baseHeight = stepperHeight/4 + baseThickness;
baseWidth = stepperWidth + baseThickness; 
baseDepth = stepperWidth + 4 * baseThickness; 



module base(){
    difference(){ 
        translate([0,0,-baseHeight/2]){
            cube([baseDepth,baseWidth,baseHeight], center = true);
        } 
        translate([0,0,5])
        {
            stepper();
        }
        translate([50,,0])
        {
            cube([50,100,50],center = true);
        }
        
    } 
} 


//dimensions for mirror stand
mirrorWidth = 2*25.4;
mirrorHeight = 1; 

module mirror(){
    translate([0,0,stepperRodHeight + stepperRodDiamter]){
        rotate([0,45,0]){
            cube([mirrorWidth, mirrorWidth, mirrorHeight], center = true);
        } 
    } 
} 

module mirrorStand(){
    difference(){
        translate([0,0,stepperRodHeight + stepperRodDiamter ]){
            difference(){
                cube([mirrorWidth*0.9, mirrorWidth, mirrorWidth* 0.9], center = true);
                rotate([0,45,0]){
                    translate([0,0,mirrorWidth/2]){
                        cube([mirrorWidth*2, mirrorWidth*2, mirrorWidth], center = true);   
                    } 
                }
                rotate([0,45,0]){
                    translate([0,0,-0.95*mirrorWidth]){
                        cube([mirrorWidth*2, mirrorWidth*2, mirrorWidth], center = true);   
                    } 
                }
            } 
        }
       stepper(); 
    }
} 

//dimensions for sensor stand
standHeight = 150;
standWidth = 4.74; 
roofWidth = baseWidth;
roofDepth = baseDepth;
pillarYOffset = baseWidth/2 - standWidth;
diagonalHeight = sqrt(standHeight * standHeight+(2*pillarYOffset)*(2*pillarYOffset))-3;
supportAngle= asin((2 * pillarYOffset)/diagonalHeight);



module sensorStand(){
    union(){
        // vertical supports
        translate([-(baseDepth/2 - standWidth),pillarYOffset,standHeight/2]){
            cube([standWidth,standWidth,standHeight], center = true);
        } 
        translate([-(baseDepth/2 - standWidth),-(pillarYOffset),standHeight/2]){
            cube([standWidth,standWidth,standHeight], center = true);
        } 
        
        // roof
        difference(){
            translate([-( roofWidth/4)-2,0, standHeight])
            {
                cube([roofDepth*2/3,roofWidth,4.74], center = true);
            } 
            translate([0,0,150])
            {
                cube([16,35,50],center = true);
            }
        }
       
        // long diagonal supports
        rotate([supportAngle,0,0]){
            translate([-(baseDepth/2 - standWidth),pillarYOffset-1,standHeight/2]){
                cube([standWidth,standWidth,diagonalHeight], center = true);
            }
        }
        rotate([-supportAngle,0,0]){
            translate([-(baseDepth/2 - standWidth),-pillarYOffset+1,standHeight/2]){
                cube([standWidth,standWidth,diagonalHeight], center = true);
            }
        }
        // short diagonal supports bottom
        translate([-(baseDepth/2 + baseThickness)/2,pillarYOffset,4]){
            rotate([0,-45,0]){
                cube([standWidth,standWidth,sqrt(25*25+25*25)],center = true);
                
            }
        } 
        translate([-(baseDepth/2 + baseThickness)/2,-pillarYOffset,4]){
            rotate([0,-45,0]){
                cube([standWidth,standWidth,sqrt(25*25+25*25)],center = true);
                
            }
        } 
        
        // short diagonal supports top
        translate([-(baseDepth/2 + baseThickness)/2,pillarYOffset,138]){
            rotate([0,45,0]){
                cube([standWidth,standWidth,sqrt(25*25+25*25)],center = true);
                
            }
        } 
        translate([-(baseDepth/2 + baseThickness)/2,-pillarYOffset,138]){
            rotate([0,45,0]){
                cube([standWidth,standWidth,sqrt(25*25+25*25)],center = true);
                
            }
        } 
    }
} 
module fullThing() {
    union()
    { 
        color("blue") base();
        color("blue") sensorStand();
    }
}  
//color ("red", 0.5) mirror();
translate([0,0,5])
{
//color ("red", 0.5) stepper();
}
rotate([0,0,0])
{
//color("blue") mirrorStand();
}
color("blue") fullThing();

