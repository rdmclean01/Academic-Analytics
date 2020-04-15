# This file uses javascript to automate photoshop. 
# I used this to to create 5000+ visual stimuli for a research project at Brigham Young University. 


#target photoshop


//pref pixels
app.preferences.rulerUnits = Units.PIXELS;

var userName = "rdmclean"; // Change this to the current user's name
/*
var temp = prompt("Please enter your username:", "byucec");
if (temp == null || temp == "" || temp == "byucec") {
  userName = "rdmclean";
  alert("Incorrect UserName. This script will hit an error. Please run again.");
 } else {
  userName = temp
 }
 */


// These paths are necessary to create the face-posture-scene combos
var pathPerson = "C:/Users/" + userName + "/Box/Reschke Research/FPC Study/Face-Posture Combos/USE for FPS Combos";
var pathScene = "C:/Users/" + userName + "/Box/Reschke Research/FPC Study/Scene Stimuli";
var pathFPS = "C:/Users/" + userName + "/Box/Reschke Research/FPC Study/Face-Posture-Scene Combos";
var pathSavePSD = "C:/Users/" + userName + "/Box/Reschke Research/FPC Study/Output_Files/AA Edited Photoshop Files";
var pathSaveJPG = "C:/Users/" + userName + "/Box/Reschke Research/FPC Study/Output_Files";



//var pathPerson = "C:/Users/" + userName + "/Documents/FPS/Face-Posture-Combos";
//var pathScene = "C:/Users/" + userName + "/Documents/FPS/Scene";
//var pathFPS = "C:/Users/" + userName + "/Documents/FPS/Unmoved";
//var pathSavePSD = "C:/Users/" + userName + "/Documents/FPS/Positioned";
//var pathSaveJPG = "C:/Users/" + userName + "/Documents/FPS/Pictures";

var dict  = new Object();
// Format = [resize percentage, X, Y] X and Y are delta movements (not absolute coordinates) in inches
dict['Anger1'] = [75, -2.569, 1.098]
dict['Anger2'] = [100, 0.292, 0.202]
dict['Anger3'] = [70, -0.057, 0.074 + 0.065] // check
dict['Anger4'] = [90, 1.014, 0.292]
dict['Anger5'] = [75, -2.403, 0.236-0.7]
dict['Disgust1'] = [75, 2.215, -0.563]
dict['Disgust2'] = [90, 0.511, 0.084]
dict['Disgust3'] = [80, 0, 0.082]
dict['Disgust4'] = [90, -2.078, 0.445]
dict['Disgust5'] = [80, 2.6, 0.97]
dict['Fear1'] = [90, -1.056, 0.908]
dict['Fear2'] = [60, -1.887, 1.191] 
dict['Fear3'] = [90, -0.554, 0.12]
dict['Fear4'] = [90, 1.048, 1.522]
dict['Fear5'] = [85, 0.37, -0.047+0.2]
dict['Joy1'] = [85, 2.563, 0.171]
dict['Joy2'] = [75, 0.37, -0.047 + 0.65] // Check
dict['Joy3'] = [120, 0, 0.425]
dict['Joy4'] = [75, 0.853, -0.182] 
dict['Joy5'] = [140, 2.833-1.2, 1.6] // Weirdest one [1.875, 1.403], [1.5, 1.389], [1.361, 1.514]  
dict['Neutral1'] = [75, 0.986, 0.583] 
dict['Neutral2'] = [70, 27.219, 11.585]
dict['Neutral3'] = [80, 0, -0.159] // check
dict['Neutral4'] = [84, 0.277, 0.369] //check
dict['Neutral5'] = [70, 0.317, 0.193]
dict['Sadness1'] = [70, 0.652, 0.231]
dict['Sadness2'] = [85, 1.681, 0.792]
dict['Sadness3'] = [85, -2.036, 0]
dict['Sadness4'] = [85, 2.75, 0.473]
dict['Sadness5'] = [60, 2.459, 0.913]

var runScene = new Object();
runScene['Anger1'] = "yes_run" 
runScene['Anger2'] = "yes_run" 
runScene['Anger3'] = "yes_run" 
runScene['Anger4'] = "yes_run" 
runScene['Anger5'] = "yes_run" 
runScene['Disgust1'] = "yes_run" 
runScene['Disgust2'] = "yes_run" 
runScene['Disgust3'] = "yes_run" 
runScene['Disgust4'] = "yes_run" 
runScene['Disgust5'] = "yes_run" 
runScene['Fear1'] = "yes_run" 
runScene['Fear2'] = "yes_run" 
runScene['Fear3'] = "yes_run" 
runScene['Fear4'] = "yes_run" 
runScene['Fear5'] = "yes_run" 
runScene['Joy1'] = "yes_run" 
runScene['Joy2'] = "yes_run" // Check
runScene['Joy3'] = "yes_run" 
runScene['Joy4'] = "yes_run" 
runScene['Joy5'] = "yes_run" // Weirdest one [1.875, 1.403], [1.5, 1.389], [1.361, 1.514]  
runScene['Neutral1'] = "yes_run" 
runScene['Neutral2'] = "yes_run" 
runScene['Neutral3'] = "yes_run" // check
runScene['Neutral4'] = "yes_run" //check
runScene['Neutral5'] = "yes_run" 
runScene['Sadness1'] = "yes_run" 
runScene['Sadness2'] = "yes_run" 
runScene['Sadness3'] = "yes_run" 
runScene['Sadness4'] = "yes_run" 
runScene['Sadness5'] = "yes_run" 

/***********************************
Here are the function calls that actually produce the desired actions
************************************/
var personFolder = new Folder(pathPerson);
var personFiles = personFolder.getFiles("*.psd");
var sceneFolder = new Folder(pathScene);
var sceneFiles = sceneFolder.getFiles("*.psd");
	//alert(sceneFolder);
//alert(sceneFiles);
for(curPerson in personFiles) {
	var pathPerson = String(personFiles[curPerson]);
	//alert(pathPerson)
	var tempPerson = pathPerson.replace(/^.*(\\|\/|\:)/, '');
	var namePerson = tempPerson.substring(0,tempPerson.length-4)
	for(curScene in sceneFiles) {
		var pathScene = String(sceneFiles[curScene]);
		
		var nameScene = getImageName(pathScene);
		//alert("nameScene = " + nameScene);
		if(runScene[nameScene] == "yes_run") { //Only if you want to run the scene. 
			var imagePerson = pathPerson;
			var imageScene = pathScene;
			// load Face-Posture & copy it
			openThisFile(imagePerson);
			activeDocument.selection.selectAll();
			activeDocument.selection.copy();
			activeDocument.selection.deselect();
			app.activeDocument.close(SaveOptions.DONOTSAVECHANGES);
				// Open Scene and paste in the Face-Posture
			openThisFile(imageScene);
			activeDocument.paste();
			
			// save the unmoved file
			var tempName = namePerson + "_" + nameScene;
			SavePSD(pathFPS, tempName, nameScene);
				
				
			// Resize the Person
			app.preferences.rulerUnits = Units.PERCENT;
			activeDocument.activeLayer.resize(dict[nameScene][0],dict[nameScene][0], AnchorPosition.MIDDLECENTER);
			// Position the Person
			app.preferences.rulerUnits = Units.INCHES;
			activeDocument.activeLayer.translate(dict[nameScene][1],dict[nameScene][2]);
			
			// Save the file as a psd and as a jpg
			SavePSD(pathSavePSD,tempName,nameScene);
			SaveJPG(pathSaveJPG,tempName,nameScene);
			
			// close the new doc
			app.activeDocument.close(SaveOptions.DONOTSAVECHANGES);
		}
	}
}

function getImageName (astring){ 
	// Box/Reschke/whatever/Image_SD_1a.jpg
	var temp1 = astring.replace(/^.*(\\|\/|\:)/, '');
	// Image_SD_1a.jpg
	temp1 += "";
	//re move extension -1
	var temp = temp1.substring(0, temp1.lastIndexOf("."));
	// return Image_SD_1a
	return temp.substring(0, temp.length); 
}

function openThisFile(masterFileNameAndPath){
	var fileRef = new File(masterFileNameAndPath)
	if (fileRef.exists) { //open that doc
      app.open(fileRef);
	}
	else {
      alert("error opening " + masterFileNameAndPath)
    }
}

function SavePSD(pathSave, saveFile, scene) {
	// Set filePath and fileName to source path
	filePath = pathSave + "/" + scene + "/" + saveFile + ".psd";
	//alert("Save Path: " + filePath);
	var psdFile = new File(filePath);

	psdSaveOptions = new PhotoshopSaveOptions();
	psdSaveOptions.embedColorProfile = true;
	psdSaveOptions.alphaChannels = true;
 
	activeDocument.saveAs(psdFile, psdSaveOptions, true, Extension.LOWERCASE);
}

function SaveJPG(fPath, fname, scene) {
	// Set filePath and fileName to source path
	filePath = fPath + "/" + scene + "/" + fname + ".jpg";
	var jpgFile = new File(filePath);
	
	jpgSaveOptions = new JPEGSaveOptions();
	jpgSaveOptions.formatOptions = FormatOptions.OPTIMIZEDBASELINE;
	jpgSaveOptions.embedColorProfile = true;
	jpgSaveOptions.matte = MatteType.NONE;
	jpgSaveOptions.quality = 12;
	
	activeDocument.saveAs(jpgFile, jpgSaveOptions, true, Extension.LOWERCASE);
}
