class Stone {

	//SETTINGS:
	float _randomness = 45; //randomness
	float _stepMaximum = 13; //step max
	float _stepMinimum = 8; //step min
	float overlapFactor = 2;
	float fadeTime = 5; //time for fading in seconds

	float _alpha = 0;
	float birth;

	//TABLE SETTINGS:
	float leftBorder, rightBorder, topBorder, bottomBorder;

	//REQUIREMENTS
	boolean isBranchStone = false;
	boolean targetIsSet = false;
	boolean dead = false;
	boolean omegaDead = false;
	int deathTime = 0;
	int imgNo;
	int[] stages = {1, 6, 15};
	int stage = 0;
	float spreadness = 22;
	float[] randomSpreadCoordonates = new float[stages.length * 2];
	float _mag;
	PVector _origin, _target, _tempTarget, _futureOrigin, _step, _centerPoint;
	boolean _fixed = false;

	int axisBlock; //stores, on what surface of the box the stone currently is

	Stone (PVector v) {
		birth = millis();

		imgNo = int(random(imageCount));

		_origin = v;
		_randomness = random(-_randomness, _randomness);
		_stepMaximum = random(_stepMinimum, _stepMaximum);

		leftBorder = ultimateOrigin.x - x_size / 2;
		rightBorder = ultimateOrigin.x + x_size / 2;
		topBorder = ultimateOrigin.y - y_size / 2;
		bottomBorder = ultimateOrigin.y + y_size / 2;

		setCurrentAxisblock();

		setRandomNumbers();
		setStage();
	}

	void setRandomNumbers(){
		// float dist = PVector.dist(ultimateOrigin.x, ultimateOrigin.y, ultimateOrigin.z, _origin.x, _origin.y, _origin.z);
		for (int i = 0; i < stages.length; ++i) {
			randomSpreadCoordonates[i] = random(-spreadness, spreadness);
			randomSpreadCoordonates[i + stages.length] = random(-spreadness, spreadness);
		}
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

	void setStage(){
		if (_origin.z == z_size){
			stage = 0;
		} else if (_origin.z == 0){
			stage = 2;
		} else if (_origin.x == leftBorder || _origin.x == rightBorder || _origin.y == topBorder || _origin.y == bottomBorder){
			stage = 1;
		} else {
			println("ERROR! couldnt set stage!");
		}
	}

	void setTarget(PVector targ) {

		_tempTarget = targ.copy();

		//sets target to zsize if on table
		if (!targetOnTableCheck()) {
			//SPAGHETTI CODE IS HERE:
			_tempTarget.z = -100;
		}

		axisBlocker();

		_step = PVector.sub(_tempTarget, _origin);
		_step.limit(_stepMaximum);
		_step = rotateRandom(_step);

		_target = PVector.add(_origin, _step);
		_futureOrigin = _target.copy();

		_step = PVector.sub(_target, _origin);
		_mag = _step.mag() * overlapFactor;
		_centerPoint = PVector.add(_origin, _step.div(2));

		collisionDetection();

		targetIsSet = true;
	}

	// void setSpread(PVector v){
	// 	float dist;
	// 	dist = PVector.dist(v.x, v.y, 0, _origin.x, _origin.y, _origin.z);


	// }

	boolean targetOnTableCheck() {
		if (_tempTarget.x > leftBorder && rightBorder > _tempTarget.x && _tempTarget.y > topBorder && bottomBorder > _tempTarget.y) {
			_tempTarget.z = z_size;
			return true;
		} else {
			return false;
		}
	}

	void collisionDetection() {

		// println("----------------");
		// println("_origin: " + _origin);
		// println("_tempTarget: "+_tempTarget);
		// println("_target: " + _target);

		switch (axisBlock) {
		case 0:
			//if in x block
			if (_origin.x == leftBorder) {
				//if on surface 2
				if (_target.z > z_size) {
					float dif = abs(_target.z - z_size);

					_target.z = z_size;
					_futureOrigin.z = z_size;
					_futureOrigin.x = _futureOrigin.x + dif;
				} else if (_target.z < 0) {
					float dif = abs(_target.z - 0);

					_target.z = 0;
					_futureOrigin.z = 0;
					_futureOrigin.x = _futureOrigin.x - dif;
				}

				if (_target.y > bottomBorder) {
					float dif = abs(_target.y - bottomBorder);

					_target.y = bottomBorder;
					_futureOrigin.y = bottomBorder;
					_futureOrigin.x = _futureOrigin.x + dif;
				} else if (_target.y < topBorder) {
					float dif = abs(topBorder - _target.y);

					_target.y = topBorder;
					_futureOrigin.y = topBorder;
					_futureOrigin.x = _futureOrigin.x - dif;
				}

			} else if (_origin.x == rightBorder) {
				//if on surface 4
				if (_target.z > z_size) {
					float dif = abs(_target.z - z_size);

					_target.z = z_size;
					_futureOrigin.z = z_size;
					_futureOrigin.x = _futureOrigin.x - dif;
				} else if (_target.z < 0) {
					float dif = abs(_target.z - 0);

					_target.z = 0;
					_futureOrigin.z = 0;
					_futureOrigin.x = _futureOrigin.x + dif;
				}

				if (_target.y > bottomBorder) {
					float dif = abs(_target.y - bottomBorder);

					_target.y = bottomBorder;
					_futureOrigin.y = bottomBorder;
					_futureOrigin.x = _futureOrigin.x - dif;
				} else if (_target.y < topBorder) {
					float dif = abs(topBorder - _target.y);

					_target.y = topBorder;
					_futureOrigin.y = topBorder;
					_futureOrigin.x = _futureOrigin.x + dif;
				}
			}
			break;
		case 1:
			//if in y block
			if (_origin.y == topBorder) {
				//if on surface 3
				if (_target.z > z_size) {
					float dif = abs(_target.z - z_size);

					_target.z = z_size;
					_futureOrigin.z = z_size;
					_futureOrigin.y = _futureOrigin.y + dif;
				} else if (_target.z < 0) {
					float dif = abs(_target.z - 0);

					_target.z = 0;
					_futureOrigin.z = 0;
					_futureOrigin.y = _futureOrigin.y - dif;
				}

				if (_target.x < leftBorder) {
					float dif = abs(_target.x - leftBorder);

					_target.x = leftBorder;
					_futureOrigin.x = leftBorder;
					_futureOrigin.y = _futureOrigin.y + dif;
				} else if (_target.x > rightBorder) {
					float dif = abs(_target.x - rightBorder);

					_target.x = rightBorder;
					_futureOrigin.x = rightBorder;
					_futureOrigin.y = _futureOrigin.y + dif;
				}
			} else if (_origin.y == bottomBorder) {
				//if on surface 1
				if (_target.z > z_size) {
					float dif = abs(_target.z - z_size);

					_target.z = z_size;
					_futureOrigin.z = z_size;
					_futureOrigin.y = _futureOrigin.y - dif;
				} else if (_target.z < 0) {
					float dif = abs(_target.z - 0);

					_target.z = 0;
					_futureOrigin.z = 0;
					_futureOrigin.y = _futureOrigin.y + dif;
				}

				if (_target.x < leftBorder) {
					float dif = abs(_target.x - leftBorder);

					_target.x = leftBorder;
					_futureOrigin.x = leftBorder;
					_futureOrigin.y = _futureOrigin.y - dif;
				} else if (_target.x > rightBorder) {
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
		// println("_futureOrigin: " + _futureOrigin);
		// println("----------------");
	}

	PVector rotateRandom(PVector v) {

		if (axisBlock == 2) {
			v.rotate(radians(_randomness));
		} else if (axisBlock == 1) {
			v = rotateAroundY(v, radians(_randomness));
		} else if (axisBlock == 0) {
			v = rotateAroundX(v, radians(_randomness));
		}

		return v;
	}

	PVector rotateAroundX(PVector v, float theta) {
		float temp = v.y;

		v.y = v.y * cos(theta) - v.z * sin(theta);
		v.z = temp * sin(theta) + v.z * cos(theta);
		return v;
	}

	PVector rotateAroundY(PVector v, float theta) {
		float temp = v.x;

		v.x = v.x * cos(theta) + v.z * sin(theta);
		v.z = -temp * sin(theta) + v.z * cos(theta);
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

	void setAlpha() {

		if (!dead) {
			//fade until alpha is 255
			_alpha = map((millis() - birth) / 1000, 0, fadeTime, 0, 255);

			if (_alpha > 222) {
				_alpha = 255;
			}
		} else {
			if (deathTime == 0) {
				deathTime = millis();
			}

			if (_alpha > 0) {

				_alpha = map((millis() - deathTime) / 1000, 0, fadeTime, 255, 0);

				// if (_alpha > map((millis() - deathTime)/1000,0,fadeTime,255,0)){

				// }

			} else {
				omegaDead = true;
			}

			if (_alpha == 0) {
				omegaDead = true;
			}
		}
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

	void drawThingy(float x, float y, float size) {
		imageMode(CENTER);
		tint(255, _alpha);
		translate(x, y);
		rotate(-atan2(_target.x - _origin.x, _target.y - _origin.y));
		image(graphics[imgNo], 0, 0, size, size);


		for (int i = 0; i < stages[stage]; ++i) {
      tint(255, _alpha);
			image(graphics[imgNo], randomSpreadCoordonates[stage], randomSpreadCoordonates[stage + stages.length], size, size);
		}

	}

//draw the stones according to its position on the mapping fields
	void drawMapping(PVector targ) {
		if (!_fixed && !targetIsSet) { //dont draw until fixed
			setTarget(targ);
		} else {

			setAlpha();

			// println("isBranchStone: "+isBranchStone);
			// println("dead: "+dead);
			// println("omegaDead: "+omegaDead);
			// println("deathTime: "+deathTime);
			// println("_alpha: "+_alpha);
			// println("------------------------------");

			fill(255, 0, 0, _alpha);

			if (_origin.z == z_size || _futureOrigin.z == z_size) {
				pushMatrix();
				translate(-ultimateOrigin.x, -ultimateOrigin.y);

				translate(offset + 3 * radius + offset, offset + z_size + offset + radius);
				noStroke();

				drawThingy(_centerPoint.x, _centerPoint.y, _mag);

				// ellipseMode(CENTER);
				// ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

				// stroke(0, _alpha);
				// line(_origin.x, _origin.y, _target.x, _target.y);
				popMatrix();
			}

			if (_origin.z == 0.0 || _futureOrigin.z == 0.0) {
				pushMatrix();
				translate(-ultimateOrigin.x, -ultimateOrigin.y);
				translate(offset + radius, offset + z_size + offset + radius);
				noStroke();

				drawThingy(_centerPoint.x, _centerPoint.y, _mag);

				// ellipseMode(CENTER);
				// ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

				// stroke(0, _alpha);
				// line(_origin.x, _origin.y, _target.x, _target.y);
				popMatrix();
			}

			if (_origin.x == leftBorder || _futureOrigin.x == leftBorder) {
				pushMatrix();
				translate(offset, offset);
				noStroke();

				drawThingy(_centerPoint.y - topBorder, z_size - _centerPoint.z, _mag);

				// ellipseMode(CENTER);
				// ellipse(_centerPoint.y - topBorder, z_size - _centerPoint.z, _mag, _mag);
				popMatrix();

			}

			if (_origin.x == rightBorder || _futureOrigin.x == rightBorder) {
				pushMatrix();
				translate(offset + y_size + x_size, offset);
				noStroke();

				drawThingy(y_size - _centerPoint.y + topBorder, z_size - _centerPoint.z, _mag);

				// ellipseMode(CENTER);
				// ellipse(y_size - _centerPoint.y + topBorder, z_size - _centerPoint.z, _mag, _mag);
				popMatrix();
			}

			if (_origin.y == topBorder || _futureOrigin.y == topBorder) {
				pushMatrix();
				translate(offset + y_size + x_size + y_size, offset);
				noStroke();

				drawThingy(x_size - _centerPoint.x + leftBorder, z_size - _centerPoint.z, _mag);

				// ellipseMode(CENTER);
				// ellipse(x_size - _centerPoint.x + leftBorder, z_size - _centerPoint.z, _mag, _mag);
				popMatrix();
			}

			if (_origin.y == bottomBorder || _futureOrigin.y == bottomBorder) {
				pushMatrix();
				translate(offset + y_size, offset);
				noStroke();

				drawThingy(_centerPoint.x - leftBorder, z_size - _centerPoint.z, _mag);

				// ellipseMode(CENTER);
				// ellipse(_centerPoint.x - leftBorder, z_size - _centerPoint.z, _mag, _mag);
				popMatrix();
			}
		}
	}
}
