ArrayList<Line> lineList = new ArrayList<Line>();

int intervall = 1,
	lastTime;
PVector target = new PVector(),
	origin = new PVector();


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
		setLines();
	}

	for (Line aLine : lineList) {
		aLine.drawLine();
	}
}

void setLines(){
	Line newestLine = lineList.get(lineList.size() - 1);
	newestLine.fix();

	lineList.add( new Line(newestLine._target));
}