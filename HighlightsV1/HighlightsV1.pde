
//SETTINGS: 

int intervall = 1;

//REQUIREMENTS:

int lastTime;

PVector target = new PVector(),
	origin = new PVector();

ArrayList<Line> lineList = new ArrayList<Line>();

void setup() {
  size(1000, 1000);

  background(255);

  origin.set(width / 2, height / 2);

  lineList.add( new Line(origin));

  lastTime = millis();
}

void draw() {
	background(255, 0);

	target.set(mouseX, mouseY);

	if (millis() > lastTime + intervall*1000){
		lastTime = millis();
		generateLine();
	}

	for (Line aLine : lineList) {
		aLine.drawLine();
	}
}

void generateLine(){
	Line newestLine = lineList.get(lineList.size() - 1);
	newestLine.fix();

	lineList.add( new Line(newestLine._target));
}