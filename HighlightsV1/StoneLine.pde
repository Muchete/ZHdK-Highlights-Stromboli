class StoneLine {

	//SETTINGS:
	int intervall = 1; //draw stone every X seconds
	float targetTolerance = 5;

	//REQUIREMENTS
	int lastTime;
	int _targetId;
	PVector _myTarget;
	PVector _origin;
	boolean active = true;
	boolean hasBranch = false;
	int branchCount = 0;
	Stone newestStone;
	ArrayList<Stone> stoneList = new ArrayList<Stone>();

	StoneLine (PVector o, int id) {
		_origin = o;
		newestStone = new Stone(_origin);
		stoneList.add(newestStone); //create first stone
		lastTime = millis();
		_targetId = id;
	}

	void update(ArrayList<PVector> l) {

		//update target if target list is not empty
		if (active){
			_myTarget = l.get(_targetId);
		}

		//generate new stone every <intervall> seconds
		if (millis() > lastTime + intervall * 1000) {
			lastTime = millis();
			if (active) {
				newStone();
			} else {
				decayStone();
			}
		}

		//draws all the stones
		drawStoneLineMapping();
	}

	void drawStoneLine() {
		//draws all the stones
		for (Stone aStone : stoneList) {
			aStone.drawStone(_myTarget);
		}
	}

	void drawStoneLineMapping() {

		//draws all the stones
		for (Stone aStone : stoneList) {
			aStone.drawMapping(_myTarget);
		}
	}

	void newStone() {
<<<<<<< HEAD
		if (stoneList.size() == 0){
=======
		if (stoneList.size() == 0) {
>>>>>>> parent of ce446d4... prepared collision detection
			stoneList.add( new Stone(_origin));
		} else {
			newestStone = stoneList.get(stoneList.size() - 1); //get latest stone
				
			//if hasn't reached target yet
			if (PVector.dist(newestStone._target, _myTarget) > targetTolerance){
				newestStone.fix(); //make latest stone solid
<<<<<<< HEAD
				stoneList.add( new Stone(newestStone._target)); //create new unsolid & invisible stone	
			}			
=======
				stoneList.add( new Stone(newestStone._target)); //create new unsolid & invisible stone
			}
>>>>>>> parent of ce446d4... prepared collision detection
		}
	}

	void decayStone() {
		if (stoneList.size() > 0){
			stoneList.remove(stoneList.size() - 1); //get latest stone
		} else {
			//remove this list?
		}
	}

	void assignId(int id){
		_targetId = id;
	}

	void deactivate(){
		active = false;
	}

}