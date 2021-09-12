// author: Urša Uršič, 2021
// This macro measures area and perimeter of a cell in a time stack, plots time evolution and saves the data to a .txt file. 

input_dir = "D:/Ursa/MAGISTERIJ/Image_analysis/OS_ND/2021_07_13/"

run("Duplicate...", "duplicate");
name = getTitle();
		
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT", "stack");

run("Gaussian Blur...", "sigma=2 stack");

run("Enhance Contrast", "saturated=0.35");

// If there are darker patches on the cell, the min and max can be adjusted to get a full mask of a cell. 
// setMinAndMax(-32000, -10000);	
run("Apply LUT", "stack");

run("Make Binary", "method=Default background=Default calculate black");

//run("Extend Image Borders", "left=1 right=1 top=0 bottom=0 front=0 back=0 fill=White");

run("Fill Holes", "stack");

//("Extend Image Borders", "left=-1 right=-1 top=0 bottom=0 front=0 back=0 fill=Replicate");


run("Set Measurements...", "area center perimeter area_fraction redirect=None decimal=3");

for (n=1; n<=nSlices; n++) {
	setSlice(n);
	setThreshold(20, 255);
	run("Create Selection");
	roiManager("Add");
}

roiManager("Measure");
Plot.create("Plot of Results", "x", "Area");
Plot.add("Circle", Table.getColumn("Area", "Results"));
Plot.setStyle(0, "blue,#a0a0ff,1.0,Circle");

j = indexOf(name, ".");
name_wo_ex = substring(name, 0, j);

saveAs("Results", input_dir+name_wo_ex+".txt");
print("Succesfully saved as "+name_wo_ex+".txt");

waitForUser;

Dialog.create("Close all?");
Dialog.show();
run("Close All");

print("done");
