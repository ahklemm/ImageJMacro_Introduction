/* 
 * NEUBIAS Academy
 * ImageJ/Fiji Macro Language
 * anna.klemm@it.uu.se - BioImage Informatics Facility @SciLifeLab
 * April 2020
 */

//batch processing
input_path = getDirectory("Choose image folder"); 
fileList = getFileList(input_path); 

for (f=0; f<fileList.length; f++){ //loops over all images in the given directory
	
	//clean-up to prepare for analysis
	roiManager("reset");	
	run("Close All");
	run("Clear Results");

	//open file
	open(input_path + fileList[f]);
	print(input_path + fileList[f]); //displays file that is processed

	//minimum particle size (px) for "Analyze particles..." command, will be used for all other images in the folder
	if(f==0){
		minSize = getNumber("minimum size", 2000); 
	}
	
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
		
	
	//Step3: Retrieve the nuclei's boundaries
	//num = getNumber("minimum size", 2000); //minimum particle size (px) for "Analyze particles..." command
	
	
	selectWindow("nuclei");
	run("Analyze Particles...", "size=" + minSize + "-Infinity add"); //add to ROI-Manager by running analyze particles
	
	//Step4: Retrieve the nuclear envelope's boundaries and save them in the ROI-Manager
	run("Clear Results");
	numberOfNuclei = roiManager("count");
	selectWindow("signal");
	for(i=0; i<numberOfNuclei; i++){
		roiManager("Select", i);
		run("Enlarge...", "enlarge=-10");
		getStatistics(area, meanNuclei, min, max, std, histogram); //get basic measurements of the nuclei 
		run("Make Band...", "band=10");
		roiManager("Update"); //original nucleus-ROI is replaced by nuclear envelope ROI
		getStatistics(area, meanNucRim, min, max, std, histogram); //get basic measurements of the nuclear membrane
		//create three columns per image: image name, meanNuclei, meanNucRim
		setResult("image", nResults, title);
		setResult("mean Int nuclei", nResults-1, meanNuclei);
		setResult("mean Int nuclear membrane", nResults-1, meanNucRim);
		ratio = meanNucRim / meanNuclei;
		setResult("ratio", nResults-1, ratio);
		setResult("minimum size nuclei", nResults-1, minSize);
	}
	// Save results with specific name
	//saveAs("results", "C:/Users/Anna/Desktop/Neubias_output/Results.csv");
	updateResults();
	saveAs("results", "C:/Users/Anna/Desktop/Neubias_output/" + title + "_results.xls");
	//waitForUser("have a look");	
} //closes loop over fileList





 