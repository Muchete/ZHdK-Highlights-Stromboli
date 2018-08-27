class StoneLine {

	//SETTINGS:
	float intervall = 0.1; //draw stone every X seconds
	float targetTolerance = 5;

	//REQUIREMENTS

	int lastTime;
	int _targetId;
	PVector _myTarget;
	PVector _origin;
	PVector tOrigin;
	boolean active = true;
	boolean isBranchLine = false;
	boolean empty = false;
	Stone newestStone;
	ArrayList<Stone> stoneList = new ArrayList<Stone>();

	StoneLine (PVector t, PVector o, int id) {
		tOrigin = t;
		_origin = o;
		newestStone = new Stone(tOrigin, _origin);
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

		if (!empty) {
			//draws all the stones
			for (Stone aStone : stoneList) {
				aStone.drawStone(_myTarget);
			}
		}
	}

	void newStone() {
		if (stoneList.size() == 0) {
			stoneList.add( new Stone(tOrigin, _origin));
		} else {
			newestStone = stoneList.get(stoneList.size() - 1); //get latest stone

			//if hasn't reached target yet
			if (PVector.dist(newestStone._target, _myTarget) > targetTolerance) {
				newestStone.fix(); //make latest stone solid
				stoneList.add( new Stone(tOrigin, newestStone._target)); //create new unsolid & invisible stone
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