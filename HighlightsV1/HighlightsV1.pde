
//SETTINGS:
PVector ultimateOrigin = new PVector(500, 500); //physical stone position

//REQUIREMENTS:
LineHandler lineHandler;
ArrayList<PVector> allTargets = new ArrayList<PVector>();

//3D SCENE PARAMETERS
int x_size = 150;
int y_size = 100;
int z_size = 100;
int radius = 200;

//------------------------------------------------------------------

void setup() {
	size(1000, 1000);

	//set table size in ultimateOrigin vector
	ultimateOrigin.z = z_size;

	//set origin of "first stone"
	lineHandler = new LineHandler();

	allTargets.add(new PVector());
}

void draw() {
	background(255, 120);
	lineHandler.update(allTargets);

	if (allTargets.size() > 0){
		allTargets.get(0).set(mouseX, mouseY, 0);
	}
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