/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ Integer (label = "Min size nuclei", value = 2000) num

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	print("Saving to: " + output);
	//clean-up to prepare for analysis
	roiManager("reset");
	run("Close All");	
	run("Clear Results");
	
	
	open(input + File.separator + file);
	//Step1: Getting image information + Normalise the data name
	//get general information
	title = getTitle();
		
		
	//split channels and rename them
	run("Split Channels");
	selectWindow("C1-" + title);
	rename("nuclei");
	selectWindow("C2-" + title);
	rename("signal");
	
		
	//Step2: Prefilter nuclear image and make binary image
	selectWindow("nuclei");
	//preprocessing of the grayscale image
	run("Median...", "radius=8");
	//thresholding
	setAutoThreshold("Huang dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	//postprocessing of binary image
	run("Fill Holes");
		
	
	//Step3: Retrieve the nuclei's boundaries
	//num = getNumber("minimum size", 2000 );
	selectWindow("nuclei");
	run("Analyze Particles...", "size=" + num + "-Infinity add"); //add to ROI-Manager by running analyze particles
	
	//Step4: Retrieve the nuclear envelope's boundaries and save them in the ROI-Manager
	numberOfNuclei = roiManager("count");
	for(i=0; i<numberOfNuclei; i++){
		roiManager("Select", i);
		run("Enlarge...", "enlarge=-10");
		run("Make Band...", "band=10");
		roiManager("Update"); //original nucleus-ROI is replaced by nuclear envelope ROI
	}
	
	
	//Step 5: Measure signal in nuclear envelope's boundaries and save the result
	run("Set Measurements...", "mean display redirect=None decimal=3"); //define the measurements
	selectWindow("signal");
	roiManager("deselect");  //ensures that no ROI is selected
	roiManager("Measure");	//measures active ROI or - if no ROI is selected - all ROIs
	// Save results 
	saveAs("results", "C:\\Users\\IT-WL-annkl878\\Desktop\\output\\" + title + "_results.xls");		
}
