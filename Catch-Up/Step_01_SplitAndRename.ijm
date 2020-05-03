/* 
 * NEUBIAS Academy
 * ImageJ/Fiji Macro Language
 * anna.klemm@it.uu.se - BioImage Informatics Facility @SciLifeLab
 * April 2020
 */

//Step1: Getting image information + Normalise the data name
//get general information
title = getTitle();
	
	
//split channels and rename them
run("Split Channels");
selectWindow("C1-" + title);
rename("nuclei");
selectWindow("C2-" + title);
rename("signal");


	








 