title = "551_C10_1.tif";

run("Split Channels");
selectWindow("C1-" + title);
rename("nuclei");

selectWindow("C2-" + title);
rename("signal");
