class StoneLine {

	//SETTINGS:
	float intervallMinimum = 0.1; //draw stone every X seconds
	float randomFactor = 8; //max Factor
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
		if (millis() > lastTime + intervallMinimum * random(1, randomFactor) * 1000) {
			lastTime = millis();
			if (active) {
				newStone();
			} else {
				decayStone();
			}
		}

		//draws all the stones
		// drawStoneLine();
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
			// for (Stone aStone : stoneList) {
			// 	aStone.drawMapping(_myTarget);
			// }

			for (int i = stoneList.size() - 1; i >= 0; --i) {
				stoneList.get(i).drawMapping(_myTarget);
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
				stoneList.add(new Stone(newestStone._futureOrigin)); //create new unsolid & invisible stone
			}
		}
	}

	void decayStone() {
		if (stoneList.size() > 0) {
			//OLD VERSION
			int newestStone = stoneList.size() - 1;

			if (!stoneList.get(newestStone).isBranchStone) {
				stoneList.remove(newestStone); //get latest stone
			}

			//new VERSION
			// //remove all omegaDead ones
			// // for (int i = stoneList.size()-1; i > 0; --i) {
			// 	if (stoneList.get(newestStone).omegaDead && !stoneList.get(newestStone).isBranchStone) {
			// 		stoneList.remove(newestStone);
			// 	}
			// // }

			// boolean isSet = false;
			// //set last undead one to dead
			// for (int i = stoneList.size()-1; i > 0; --i) {
			// 	if (!isSet && !stoneList.get(i).dead && !stoneList.get(i).isBranchStone) {
			// 		stoneList.get(i).dead = true;
			// 		isSet = true;
			// 	}
			// }

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
