//This macro calculates the ratio of two images to get the mean cleavage efficiency of CCF4-AM. 
//The macro includes Ratio Plus plugin by Paulo Magalh�es (https://imagej.nih.gov/ij/plugins/ratio-plus.html).
// Ver 1.5, 2022

run("3-3-2 RGB");
title = getTitle;
run("Subtract Background...", "rolling=50 sliding stack");
rename("Image");
run("Gaussian Blur...", "sigma=2");
//Measure background areas in each channel
waitForUser("Draw backgroud area");
setBatchMode(true);
Stack.setChannel(1);
run("Measure");
List.setMeasurements;
BkgCh1 = List.getValue("Mean");
Stack.setChannel(2);
run("Measure");
List.setMeasurements;
BkgCh2 = List.getValue("Mean");
run("Select None");
run("Split Channels");
Ch1 = "C1-Image";
Ch2 = "C2-Image";
// Calculate Ratio image 
run("Ratio Plus", "image1=" +Ch2+" image2="+Ch1+" background1="+BkgCh2+" clipping_value1=0 background2="+BkgCh1+" clipping_value2=0 multiplication=2");
rename("Ratio");
// Create Mask of area occupied by cells 
selectWindow(Ch1);
run("Duplicate...", "...");
run("Gaussian Blur...", "sigma=1");
setAutoThreshold("Triangle dark");
run("Create Mask");
run("Erode");
run("Divide...", "value=255.000");
//Measure  mean value of ratio in image area occupied by cells
imageCalculator("Divide create 32-bit", "Ratio","mask"); 
rename(title+"_ratio");
run("Clear Results");
run("Measure"); 	
setBatchMode(false);
//Apply LUT  Ratio to final image
run("Ratio"); 
setMinAndMax(0, 3);
