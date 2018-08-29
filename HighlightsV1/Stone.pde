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
	float leftBorder, rightBorder, topBorder, bottomBorder, tableZ;

	//REQUIREMENTS
	boolean isBranchStone = false;
	boolean targetIsSet = false; 
	float _mag;
	PVector _origin, _target, _tempTarget, _futureOrigin, _step, _centerPoint;
	boolean _fixed = false;

	int axisBlock; //stores, on what surface of the box the stone currently is

	Stone (PVector tOrigin, PVector v) {
		tableOrigin = tOrigin;
		_origin = v;
		_randomness = random(-_randomness, _randomness);
		_stepMaximum = random(_stepMinimum, _stepMaximum);


		leftBorder = tableOrigin.x - tableWidth / 2;
		rightBorder = tableOrigin.x + tableWidth / 2;
		topBorder = tableOrigin.y - tableHeight / 2;
		bottomBorder = tableOrigin.y + tableHeight / 2;
		tableZ = tableOrigin.z;
		setCurrentAxisblock();
	}

	void setCurrentAxisblock() {
		//if on flat surface
		if (_origin.z == tableZ || _origin.z == 0) {
			axisBlock = 2;
		} else {
			if (_origin.x == leftBorder || _origin.x == rightBorder){
				axisBlock = 0;
			} else if (_origin.y == topBorder || _origin.y == bottomBorder){
				axisBlock = 1;
			} else {
				println("ERROR! couldn't determine surface of stone!");	
				println("_origin: "+_origin);
			}
		}
	}

	void setTarget(PVector targ) {

		_tempTarget = targ.copy();

		axisBlocker();

		_step = PVector.sub(_tempTarget, _origin);
		_step.limit(_stepMaximum);
		_step = rotateRandom(_step);

		println("_origin: "+_origin);

		_target = PVector.add(_origin, _step);
		_futureOrigin = _target.copy();

		collisionDetection();

		_step = PVector.sub(_target, _origin);
		_mag = _step.mag();
		_centerPoint = PVector.add(_origin, _step.div(2));

		targetIsSet = true;
	}

	void collisionDetection() {

		switch (axisBlock) {
		case 0:
			//if in x block

			break;
		case 1:
			//if in y block

			break;
		case 2:
			//if in z block
			if (_origin.z == tableZ) {
				//if on table
				if (_target.x > leftBorder && _target.x < rightBorder) {
					//vertical breach
					if (_target.y > bottomBorder) {
						float dif = abs(_target.y - bottomBorder);

						_target.y = bottomBorder; 
						_futureOrigin.y = bottomBorder;
						_futureOrigin.z = _futureOrigin.z - dif;

					} else if (_target.y < topBorder){
						float dif = abs(topBorder - _target.y);

						_target.y = topBorder; 
						_futureOrigin.y = topBorder;
						_futureOrigin.z = _futureOrigin.z - dif;

					}
				} else if (_target.y > topBorder && _target.y < bottomBorder) {
					//horizontal breach!
					if (_target.x > rightBorder){
						float dif = abs(_target.x - rightBorder);

						_target.x = rightBorder;
						_futureOrigin.x = rightBorder;
						_futureOrigin.z = _futureOrigin.z - dif;

					} else if (_target.x < leftBorder) {
						float dif = abs(leftBorder - _target.x);

						_target.x = leftBorder;
						_futureOrigin.x = leftBorder;
						_futureOrigin.z = _futureOrigin.z - dif;

					}
				}
			} else if (_origin.z == 0){
				//if on table
				// if (_target.x > leftBorder && _target.x < rightBorder) {
				// 	//vertical breach
				// 	if (_target.y < bottomBorder) {
				// 		float dif = abs(_target.y - bottomBorder);

				// 		_target.y = bottomBorder; 
				// 		_futureOrigin.y = bottomBorder;
				// 		_futureOrigin.z = _futureOrigin.z + dif;

				// 	} else if (_target.y > topBorder){
				// 		float dif = abs(topBorder - _target.y);

				// 		_target.y = topBorder; 
				// 		_futureOrigin.y = topBorder;
				// 		_futureOrigin.z = _futureOrigin.z + dif;

				// 	}
				// } else if (_target.y > topBorder && _target.y < bottomBorder) {
				// 	//horizontal breach!
				// 	if (_target.x < rightBorder){
				// 		float dif = abs(_target.x - rightBorder);

				// 		_target.x = rightBorder;
				// 		_futureOrigin.x = rightBorder;
				// 		_futureOrigin.z = _futureOrigin.z + dif;

				// 	} else if (_target.x > leftBorder) {
				// 		float dif = abs(leftBorder - _target.x);

				// 		_target.x = leftBorder;
				// 		_futureOrigin.x = leftBorder;
				// 		_futureOrigin.z = _futureOrigin.z + dif;
						
				// 	}
				// }
			}
			break;
		}
	}

	PVector rotateRandom(PVector v){

		if (axisBlock == 2){
			_step.rotate(radians(_randomness));	
		} else {

		}

		return v;
	}

	void axisBlocker(){

		//blocks axis depending on current surface
		switch (axisBlock) {
		case 0:
			_tempTarget.x = _origin.x;
			break;
		case 1:
			_tempTarget.y = _origin.y;
			break;
		case 2:
			_tempTarget.z = _origin.z;
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

		if (!_fixed && !targetIsSet) { //dont draw until fixed
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