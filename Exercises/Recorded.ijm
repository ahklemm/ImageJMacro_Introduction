run("Split Channels");
selectWindow("C1-711_D6_1.tif");
rename("nuclei");
selectWindow("C2-711_D6_1.tif");
rename("signal");

selectWindow("nuclei");
run("Median...", "radius=8");
setAutoThreshold("Huang dark");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");

run("Analyze Particles...", "size=2000-Infinity add");
roiManager("Show None");

roiManager("Select", 7);
run("Enlarge...", "enlarge=-10");
run("Make Band...", "band=10");
roiManager("Update");

run("Set Measurements...", "mean display redirect=None decimal=3");
selectWindow("signal");
roiManager("Select", 7);
run("Measure");




