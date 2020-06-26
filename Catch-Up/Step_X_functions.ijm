/* 
 * NEUBIAS Academy
 * ImageJ/Fiji Macro Language
 * anna.klemm@it.uu.se - BioImage Informatics Facility @SciLifeLab
 * April 2020
 */

//batch processing
input_dir = getDirectory("Choose image folder");
output_dir = getDirectory("Choose output folder");
fileList = getFileList(input_dir); 

minimumNucleusSize = getNumber("minimum size", 2000); 

setBatchMode(true); // can speed up things dramatically
for (f=0; f<fileList.length; f++){ 
	process( input_dir, fileList[ f ], minimumNucleusSize, output_dir );		
} 
setBatchMode(false);

function process( input_dir, file, minimumNucleusSize, output_dir )
{
	//clean-up to prepare for analysis
	roiManager("reset");	
	run("Close All");
	run("Clear Results");

	//open file
	open(input_dir + file);
	print(input_dir + file); //displays file that is processed

	//Step1: Getting image information + normalise the data name
	//get general information
	title = getTitle();
	
	//split channels and rename them
	run("Split Channels");
	selectWindow("C1-"+title);
	rename("nuclei");
	selectWindow("C2-"+title);
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
		
	selectWindow("nuclei");
	run("Analyze Particles...", "size=" + minimumNucleusSize + "-Infinity add"); //add to ROI-Manager by running analyze particles
	
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
	
	// Save results with specific name
	//saveAs("results", "C:/Users/Anna/Desktop/Neubias_output/Results.csv");
	saveAs("results", output_dir + title + "_results.xls");
}



 