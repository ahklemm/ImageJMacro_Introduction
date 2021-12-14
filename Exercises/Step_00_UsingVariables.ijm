title = "551_C10_1.tif";

run("Split Channels");
selectWindow("C1-551_C10_1.tif");
rename("nuclei");

selectWindow("C2-551_C10_1.tif");
rename("signal");
