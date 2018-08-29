class Stone {

	//SETTINGS:

	float _randomness = 45;
	float _stepMaximum = 25;
	float _stepMinimum = 20;

	float _alpha = 255;

	//TABLE SETTINGS:
	float leftBorder, rightBorder, topBorder, bottomBorder;

	//REQUIREMENTS
	boolean isBranchStone = false;
	boolean targetIsSet = false;
	float _mag;
	PVector _origin, _target, _tempTarget, _futureOrigin, _step, _centerPoint;
	boolean _fixed = false;

	int axisBlock; //stores, on what surface of the box the stone currently is

	Stone (PVector v) {
		_origin = v;
		_randomness = random(-_randomness, _randomness);
		_stepMaximum = random(_stepMinimum, _stepMaximum);


		leftBorder = ultimateOrigin.x - x_size / 2;
		rightBorder = ultimateOrigin.x + x_size / 2;
		topBorder = ultimateOrigin.y - y_size / 2;
		bottomBorder = ultimateOrigin.y + y_size / 2;

		setCurrentAxisblock();
	}

	void setCurrentAxisblock() {
		//if on flat surface
		if (_origin.z == z_size || _origin.z == 0) {
			axisBlock = 2;
		} else {
			if (_origin.x == leftBorder || _origin.x == rightBorder) {
				axisBlock = 0;
			} else if (_origin.y == topBorder || _origin.y == bottomBorder) {
				axisBlock = 1;
			} else {
				println("ERROR! couldn't determine surface of stone!");
				println("_origin: " + _origin);
			}
		}
	}

	void setTarget(PVector targ) {

		_tempTarget = targ.copy();

		axisBlocker();

		_step = PVector.sub(_tempTarget, _origin);
		_step.limit(_stepMaximum);
		_step = rotateRandom(_step);

		_target = PVector.add(_origin, _step);
		_futureOrigin = _target.copy();

		collisionDetection();

		_step = PVector.sub(_target, _origin);
		_mag = _step.mag();
		_centerPoint = PVector.add(_origin, _step.div(2));

		targetIsSet = true;
	}

	void collisionDetection() {

	println("----------------");
	println("_origin: " + _origin);
	println("_tempTarget: "+_tempTarget);
	println("_target: " + _target);

		switch (axisBlock) {
		case 0:
			//if in x block
			// if (_origin.x == leftBorder){
			// 	//if on surface 2
			// 	if (_target.z > z_size){
			// 		float dif = abs(_target.z - z_size);

			// 		_target.z = z_size;
			// 		_futureOrigin.z = z_size;
			// 		_futureOrigin.x = _futureOrigin.x + dif;
			// 	} else if (_target.z < 0){
			// 		float dif = abs(_target.z - 0);

			// 		_target.z = 0;
			// 		_futureOrigin.z = 0;
			// 		_futureOrigin.x = _futureOrigin.x - dif;
			// 	}

			// 	if (_target.y > bottomBorder) {
			// 		float dif = abs(_target.y - bottomBorder);

			// 		_target.y = bottomBorder;
			// 		_futureOrigin.y = bottomBorder;
			// 		_futureOrigin.x = _futureOrigin.x + dif;
			// 	} else if (_target.y < topBorder){
			// 		float dif = abs(topBorder - _target.y);

			// 		_target.y = topBorder;
			// 		_futureOrigin.y = topBorder;
			// 		_futureOrigin.x = _futureOrigin.x - dif;
			// 	}

			// } else if (_origin.x == rightBorder){
			// 	//if on surface 4
			// 	if (_target.z > z_size){
			// 		float dif = abs(_target.z - z_size);

			// 		_target.z = z_size;
			// 		_futureOrigin.z = z_size;
			// 		_futureOrigin.x = _futureOrigin.x - dif;
			// 	} else if (_target.z < 0){
			// 		float dif = abs(_target.z - 0);

			// 		_target.z = 0;
			// 		_futureOrigin.z = 0;
			// 		_futureOrigin.x = _futureOrigin.x + dif;
			// 	}

			// 	if (_target.y > bottomBorder) {
			// 		float dif = abs(_target.y - bottomBorder);

			// 		_target.y = bottomBorder;
			// 		_futureOrigin.y = bottomBorder;
			// 		_futureOrigin.x = _futureOrigin.x - dif;
			// 	} else if (_target.y < topBorder){
			// 		float dif = abs(topBorder - _target.y);

			// 		_target.y = topBorder;
			// 		_futureOrigin.y = topBorder;
			// 		_futureOrigin.x = _futureOrigin.x + dif;
			// 	}
			// }
			break;
		case 1:
			//if in y block
			// if (_origin.y == topBorder){
			// 	//if on surface 3
			// 	if (_target.z > z_size){
			// 		float dif = abs(_target.z - z_size);

			// 		_target.z = z_size;
			// 		_futureOrigin.z = z_size;
			// 		_futureOrigin.y = _futureOrigin.y + dif;
			// 	} else if (_target.z < 0){
			// 		float dif = abs(_target.z - 0);

			// 		_target.z = 0;
			// 		_futureOrigin.z = 0;
			// 		_futureOrigin.y = _futureOrigin.y - dif;
			// 	}

			// 	if (_target.x < leftBorder){
			// 		float dif = abs(_target.x - leftBorder);

			// 		_target.x = leftBorder;
			// 		_futureOrigin.x = leftBorder;
			// 		_futureOrigin.y = _futureOrigin.y + dif;
			// 	} else if (_target.x > rightBorder){
			// 		float dif = abs(_target.x - rightBorder);

			// 		_target.x = rightBorder;
			// 		_futureOrigin.x = rightBorder;
			// 		_futureOrigin.y = _futureOrigin.y + dif;
			// 	}
			// } else 
			if (_origin.y == bottomBorder){
				//if on surface 1
				if (_target.z > z_size){
					float dif = abs(_target.z - z_size);

					_target.z = z_size;
					_futureOrigin.z = z_size;
					_futureOrigin.y = _futureOrigin.y - dif;
				} else if (_target.z < 0){
					float dif = abs(_target.z - z_size);

					_target.z = 0;
					_futureOrigin.z = 0;
					_futureOrigin.y = _futureOrigin.y + dif;
				}

				if (_target.x < leftBorder){
					float dif = abs(_target.x - leftBorder);

					_target.x = leftBorder;
					_futureOrigin.x = leftBorder;
					_futureOrigin.y = _futureOrigin.y - dif;
				} else if (_target.x > rightBorder){
					float dif = abs(_target.x - rightBorder);

					_target.x = rightBorder;
					_futureOrigin.x = rightBorder;
					_futureOrigin.y = _futureOrigin.y - dif;
				}
			}
			break;
		case 2:
			if (_origin.z == z_size) {
				//vertical breach
				if (_target.y > bottomBorder) {
					float dif = abs(_target.y - bottomBorder);

					_target.y = bottomBorder;
					_futureOrigin.y = bottomBorder;
					_futureOrigin.z = _futureOrigin.z - dif;

				} else if (_target.y < topBorder) {
					float dif = abs(topBorder - _target.y);

					_target.y = topBorder;
					_futureOrigin.y = topBorder;
					_futureOrigin.z = _futureOrigin.z - dif;
				}

				//horizontal breach
				if (_target.x > rightBorder) {
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
			} else if (_origin.z == 0) {
				//if on floor
				if (leftBorder < _target.x && _target.x < rightBorder) {
						//vertical breach
					if (_origin.y < topBorder && topBorder < _target.y) {
						float dif = abs(topBorder - _target.y);

						_target.y = topBorder;
						_futureOrigin.y = topBorder;
						_futureOrigin.z = _futureOrigin.z + dif;
					} else if (_origin.y > bottomBorder && bottomBorder > _target.y) {
						float dif = abs(bottomBorder - _target.y);

						_target.y = bottomBorder;
						_futureOrigin.y = bottomBorder;
						_futureOrigin.z = _futureOrigin.z + dif;
					}
				}
			}
			break;
		}
	println("_futureOrigin: " + _futureOrigin);
	println("----------------");
	}

	PVector rotateRandom(PVector v) {

		if (axisBlock == 2) {
			_step.rotate(radians(_randomness));
		} else {

		}

		return v;
	}

	void axisBlocker() {

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

		if (!_fixed && !targetIsSet) { //dont draw until fixed
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
			// fill(255, 0, 0, _alpha);
			fill(map(_centerPoint.z, 0, 100, 0, 255), map(_centerPoint.z, 0, 100, 255, 0), 0, _alpha);

			if (_centerPoint.z == z_size) {
				pushMatrix();
				translate(-width / 2, -height / 2);
				translate(10 + 3 * radius + 10, 10 + z_size + 10 + radius);
				ellipseMode(CENTER);
				ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

				stroke(0, _alpha);
				line(_origin.x, _origin.y, _target.x, _target.y);
				popMatrix();
			} else if (_centerPoint.z == 0.0) {
				pushMatrix();
				translate(-width / 2, -height / 2);
				translate(10 + radius, 10 + z_size + 10 + radius);
				ellipseMode(CENTER);
				ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

				stroke(0, _alpha);
				line(_origin.x, _origin.y, _target.x, _target.y);
				popMatrix();
			} else if (false) {

			}
		}
	}
}