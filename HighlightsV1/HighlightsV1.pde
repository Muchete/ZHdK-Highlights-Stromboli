import codeanticode.syphon.*;

//COMMUNICATION WITH RESOLUME
SyphonServer server;

//SETTINGS:
PVector stoneOrigin = new PVector(460,530); //physical stone position
PVector ultimateOrigin = new PVector(500, 500); //physical TABLE positon
int imageCount = 3;

//REQUIREMENTS:
LineHandler lineHandler;
ArrayList<PVector> allTargets = new ArrayList<PVector>();
PImage[] graphics;

//3D SCENE PARAMETERS
float factor = 1.5;
float x_size = 160 * factor; //80cm
float y_size = 96 * factor; //48cm
float z_size = 115 * factor; //57.5cm
float radius = 200 * factor;

//2D SCENE PARAMETERS
int offset = 20; // defines the space between the mapping fields

//------------------------------------------------------------------

void setup() {
	size(1920, 1080, P3D);

	//create syphon server for sending the screen to resolume
	server = new SyphonServer(this, "Processing");

	//set table size in ultimateOrigin vector
	ultimateOrigin.z = z_size;
	stoneOrigin.z = z_size;



	//set origin of "first stone"
	lineHandler = new LineHandler();

	allTargets.add(new PVector());
}

void draw() {
	// background(255, 120);
	lineHandler.update(allTargets);

	if (allTargets.size() > 0){
		allTargets.get(0).set(mouseX, mouseY, 0);
	}

	server.sendScreen();
}

//for debugging only
void mouseClicked() {
	allTargets.add(new PVector(mouseX, mouseY, 0));
	println("added Target Nr. "+allTargets.size()+"!");
	println("allTargets: "+allTargets);
}

//for debugging only
void keyPressed(){
	if (allTargets.size() > 0){
		allTargets.remove(0);
	}
	println("removed Target!");
	println("allTargets: "+allTargets);
	
}
