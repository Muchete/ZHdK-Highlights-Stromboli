
//SETTINGS:
PVector ultimateOrigin = new PVector(500, 500);

//REQUIREMENTS:
LineHandler lineHandler;
ArrayList<PVector> allTargets = new ArrayList<PVector>();

//------------------------------------------------------------------

void setup() {
	size(1000, 1000);

	lineHandler = new LineHandler(ultimateOrigin);
}

void draw() {
	background(255, 120);
	lineHandler.update(allTargets);
}





//for debugging only
void mouseClicked() {
	allTargets.add(new PVector(mouseX, mouseY));
	println("added Target!");
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
