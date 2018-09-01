import codeanticode.syphon.*;
import ddf.minim.*;
import org.openkinect.processing.*;

//DEBUGGING:
boolean debugMode = true;

//VISITOR DETECTION
Kinect kinect;
BlobHandler blobHandler;

boolean touched = false;

int lowerThreshold = 700;
int upperThreshold = 930;

PVector centerPoint;

//COMMUNICATION WITH RESOLUME
SyphonServer server;

//REQUIREMENTS:
LineHandler lineHandler;
Minim m = new Minim (this);
SoundHandler soundHandler;
ArrayList<PVector> allTargets = new ArrayList<PVector>();
PImage[] graphics;

//3D SCENE PARAMETERS
float factor = 1.7;
float x_size = 160 * factor; //80cm
float y_size = 96 * factor; //48cm
float z_size = 115 * factor; //57.5cm
float radius = 200 * factor;

PVector stoneOrigin = new PVector(420, 523); //physical stone position
PVector ultimateOrigin = new PVector(500, 500); //physical TABLE positon
int imageCount = 9;

//2D SCENE PARAMETERS
int offset = 20; // defines the space between the mapping fields

//------------------------------------------------------------------

void setup() {
	size(1920, 1080, P3D);

	//init kinect v1
	kinect = new Kinect(this);
	kinect.initDepth();

	//create blobHandler
	blobHandler = new BlobHandler();
	centerPoint = new PVector(320, 240);

	//create syphon server for sending the screen to resolume
	server = new SyphonServer(this, "Processing");

	//set table size in ultimateOrigin vector
	ultimateOrigin.z = z_size;
	stoneOrigin.z = z_size;

	//load sounds
	soundHandler = new SoundHandler();

	//set origin of "first stone"
	lineHandler = new LineHandler();

	//allTargets.add(new PVector());
}

void draw() {

	//image handling for the blob detection
	PImage img = kinect.getDepthImage();
	PImage result = new PImage(640, 480);
	int[] depthMap = kinect.getRawDepth();

	result.loadPixels();

	for (int x = 0; x < 640; x++) {
		for (int y = 0; y < 480; y++) {
			int loc = x + y * 640;
			int rawDepth = depthMap[loc];

			if (rawDepth > lowerThreshold && rawDepth < upperThreshold) {
				result.pixels[loc] = blobHandler.trackColor;
			} else {
				result.pixels[loc] = img.pixels[loc];
			}
		}
	}

	result.updatePixels();

	blobHandler.update(result);
	allTargets = blobHandler.activeBlobs(centerPoint, 0, 250);

	// println(allTargets);

	// background(255, 120);
	lineHandler.update(allTargets);

	// if (allTargets.size() > 0){
	// 	allTargets.get(0).set(mouseX, mouseY, 0);
	// }

	//image(result, 0, 0);

	server.sendScreen();
}

//for debugging only
// void mouseClicked() {
// 	allTargets.add(new PVector(mouseX, mouseY, 0));
// 	println("added Target Nr. "+allTargets.size()+"!");
// 	println("allTargets: "+allTargets);
// 	// soundHandler.playRandom();
// }

//for debugging only
// void keyPressed(){
// 	if (allTargets.size() > 0){
// 		allTargets.remove(0);
// 	}
// 	println("removed Target!");
// 	println("allTargets: "+allTargets);

// }
