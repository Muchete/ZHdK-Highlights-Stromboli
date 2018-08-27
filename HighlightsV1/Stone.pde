<<<<<<< HEAD
class Stone { 

    //SETTINGS:

    float _randomness = 45;
    float _stepLimit = 30;
    float _stepMinimum = 10;

    float _alpha = 255;

    //REQUIREMENTS

    float _mag;
    PVector _origin, _target, _step, _centerPoint;
    boolean _fixed = false;

    Stone (PVector v) {  
        _origin = v;
        _randomness = random(-_randomness, _randomness);
        _stepLimit = random(_stepMinimum, _stepLimit);
    } 

    void setTarget(float x, float y){

        _target = new PVector(x,y);

        _step = PVector.sub(_target, _origin);
        _step.limit(_stepLimit);
        _step.rotate(radians(_randomness));

        _target = PVector.add(_origin, _step);
        _mag = _step.mag();
        _centerPoint = PVector.add(_origin, _step.div(2));

    }

    void fix(){
        _fixed = true;
    }

    void drawStone(PVector targ) {

        if (!_fixed){ //dont draw until fixed
            setTarget(targ.x, targ.y);
        } else {
            noStroke();
            fill(255, 0, 0, _alpha);

            ellipseMode(CENTER);
            ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

            stroke(0, _alpha);
            line(_origin.x, _origin.y, _target.x, _target.y);
        }
    }

    void drawMapping(PVector targ) {

        if (!_fixed){ //dont draw until fixed
            setTarget(targ.x, targ.y);
        } else {
            noStroke();
            fill(255, 0, 0, _alpha);

            if (abs(_centerPoint.x - width/2) < x_size/2 && abs(_centerPoint.y - height/2) < y_size/2 ) {
                pushMatrix();
                translate(-width/2, -height/2);
                translate(10 + 3 * radius + 10, 10 + z_size + 10 + radius);
                ellipseMode(CENTER);
                ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

                stroke(0, _alpha);
                line(_origin.x, _origin.y, _target.x, _target.y);
                popMatrix();
            } 
            else if (abs(_centerPoint.x - width/2) > x_size/2 || abs(_centerPoint.y - height/2) > y_size/2 ) {
                pushMatrix();
                translate(-width/2, -height/2);
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




=======
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

	int surface = 5; //stores, on what surface of the box the stone currently is

	Stone (PVector v) {
		_origin = v;
		_randomness = random(-_randomness, _randomness);
		_stepLimit = random(_stepMinimum, _stepLimit);
	}

	void setTarget(PVector targ) {

		//add axis blocking for certain positions
		switch (surface) {
		case 0:
		case 5:
			targ.z = _origin.z;
			break;
		case 1:
		case 3:
			targ.y = _origin.y;
			break;
		case 2:
		case 4
			targ.x = _origin.x;
			break;
		}


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
>>>>>>> parent of ce446d4... prepared collision detection
