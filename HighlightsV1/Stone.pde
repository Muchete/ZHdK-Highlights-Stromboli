class Stone {

	//SETTINGS:

	float _randomness = 45;
	float _stepMaximum = 25;
	float _stepMinimum = 20;

	float _alpha = 255;

	//TABLE SETTINGS:
	PVector tableOrigin;
	float tableWidth = 500;
	float tableHeight = 300;

	//REQUIREMENTS
	boolean isBranchStone = false;
	float _mag;
	PVector _origin, _target, _step, _centerPoint;
	boolean _fixed = false;

	int surface = 5; //stores, on what surface of the box the stone currently is

	Stone (PVector tOrigin, PVector v) {
		tableOrigin = tOrigin;
		_origin = v;
		_randomness = random(-_randomness, _randomness);
		_stepMaximum = random(_stepMinimum, _stepMaximum);
	}

	void setTarget(PVector targ) {

		_target = targ;

		_step = PVector.sub(_target, _origin);
		_step.limit(_stepMaximum);
		_step.rotate(radians(_randomness));

		collisionDetection();

		_target = PVector.add(_origin, _step);
		_mag = _step.mag();
		_centerPoint = PVector.add(_origin, _step.div(2));

	}

	void collisionDetection() {

		PVector tempTarget = PVector.add(_origin, _step);

		float leftBorder = tableOrigin.x - tableWidth / 2;
		float rightBorder = tableOrigin.x + tableWidth / 2;
		float topBorder = tableOrigin.y - tableHeight / 2;
		float bottomBorder = tableOrigin.y + tableHeight / 2;


		switch (surface) {
		case 0:

			if (tempTarget.x > leftBorder && tempTarget.x < rightBorder) {
				//vertical breach
				if (tempTarget.y > bottomBorder) {
					println("nach unten weg!");



					surface = 1;
				} else if (tempTarget.y < topBorder) {
					println("nach oben weg");



					surface = 3;
				}
			} else if (tempTarget.y > topBorder && tempTarget.y < bottomBorder) {
				//horizontal breach!
				if (tempTarget.x > rightBorder) {
					println("nach rechts weg");



					surface = 4;
				} else if (tempTarget.x < leftBorder) {
					println("nach links weg");



					surface = 2;
				}
			}

			break;
		case 1:
		case 3:

			break;
		case 2:
		case 4:

			break;
		}
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

//draw the stones according to its position on the mapping fields
	void drawMapping(PVector targ) {

		if (!_fixed) { //dont draw until fixed
			setTarget(targ);
		} else {
			noStroke();
			fill(255, 0, 0, _alpha);

			if (abs(_centerPoint.x - width / 2) < x_size / 2 && abs(_centerPoint.y - height / 2) < y_size / 2 ) {
				pushMatrix();
				translate(-width / 2, -height / 2);
				translate(10 + 3 * radius + 10, 10 + z_size + 10 + radius);
				ellipseMode(CENTER);
				ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

				stroke(0, _alpha);
				line(_origin.x, _origin.y, _target.x, _target.y);
				popMatrix();
			} else if (abs(_centerPoint.x - width / 2) > x_size / 2 || abs(_centerPoint.y - height / 2) > y_size / 2 ) {
				pushMatrix();
				translate(-width / 2, -height / 2);
				translate(10 + radius, 10 + z_size + 10 + radius);
				ellipseMode(CENTER);
				ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

				stroke(0, _alpha);
				line(_origin.x, _origin.y, _target.x, _target.y);
				popMatrix();
			}
		}
	}
}