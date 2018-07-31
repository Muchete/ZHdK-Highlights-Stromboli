
//SETTINGS: 

int intervall = 1;


//REQUIREMENTS:

int lastTime;

PVector target = new PVector(),
	origin = new PVector();

ArrayList<Stone> stoneList = new ArrayList<Stone>();

void setup() {
  size(1000, 1000);

  background(255);

  origin.set(width / 2, height / 2);

  stoneList.add( new Stone(origin));

  lastTime = millis();

}

void draw() {
	background(255, 0);

	target.set(mouseX, mouseY);

	if (millis() > lastTime + intervall*1000){
		lastTime = millis();
		generateLine();
	}

	for (Stone aLine : stoneList) {
		stroke(0);
		aLine.drawStone();
	}
}

void generateLine(){
	Stone newestStone = stoneList.get(stoneList.size() - 1);
	newestStone.fix();

	stoneList.add( new Stone(newestStone._target));
}