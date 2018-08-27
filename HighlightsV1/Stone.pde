class Stone {

	//SETTINGS:

	float _randomness = 45;
	float _stepLimit = 30;
	float _stepMinimum = 10;

	float _alpha = 255;

	//REQUIREMENTS
	boolean isBranchStone = false;
	float _mag;
	PVector _origin, _target, _step, _centerPoint;
	boolean _fixed = false;

	int surface = 0; //stores, on what surface of the box the stone currently is

	Stone (PVector v) {
		_origin = v;
		_randomness = random(-_randomness, _randomness);
		_stepLimit = random(_stepMinimum, _stepLimit);
	}

	void setTarget(PVector targ) {

		_target = targ;

		_step = PVector.sub(_target, _origin);
		_step.limit(_stepLimit);
		_step.rotate(radians(_randomness));

		_target = PVector.add(_origin, _step);
		_mag = _step.mag();
		_centerPoint = PVector.add(_origin, _step.div(2));

	}

	void fix() {
		_fixed = true;
	}

	void drawStone(PVector targ) {

		if (!_fixed) { //dont draw until fixed
			setTarget(targ);
		} else {
			noStroke();
			fill(255, 0, 0, _alpha);

			ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

			stroke(0, _alpha);
			line(_origin.x, _origin.y, _target.x, _target.y);
		}
	}
}