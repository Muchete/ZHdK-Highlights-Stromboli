class StoneLine {

	//SETTINGS:
	float intervall = 0.5; //draw stone every X seconds
	float targetTolerance = 5;

	//REQUIREMENTS
	int lastTime;
	int _targetId;
	PVector _myTarget;
	PVector _origin;
	boolean active = true;
	boolean isBranchLine = false;
	boolean empty = false;
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
		if (active) {
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
		if (!empty) {
			//draws all the stones
			for (Stone aStone : stoneList) {
				aStone.drawStone(_myTarget);
			}
		}
	}

	void drawStoneLineMapping() {
		if (!empty) {
			//draws all the stones
			for (Stone aStone : stoneList) {
				aStone.drawMapping(_myTarget);
			}
		}
	}

	void newStone() {
		if (stoneList.size() == 0) {
			stoneList.add( new Stone(_origin));
		} else {
			newestStone = stoneList.get(stoneList.size() - 1); //get latest stone

			//if hasn't reached target yet
			if (PVector.dist(newestStone._futureOrigin, _myTarget) > targetTolerance) {
				newestStone.fix(); //make latest stone solid
				stoneList.add( new Stone(newestStone._futureOrigin)); //create new unsolid & invisible stone
			}
		}
	}

	void decayStone() {
		if (stoneList.size() > 0) {
			//check if stone is branched.
			if (!stoneList.get(stoneList.size() - 1).isBranchStone) {
				stoneList.remove(stoneList.size() - 1); //get latest stone
			}
		} else {
			//remove this line
			empty = true;
		}
	}

	void assignId(int id) {
		_targetId = id;
	}

	void deactivate() {
		active = false;
	}

}