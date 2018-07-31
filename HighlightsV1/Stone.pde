class Stone { 

	//SETTINGS:

	float _randomness = 45;
  	float _stepLimit = 30;
  	float _stepMinimum = 10;

  	int _alpha = 255;


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

  	void drawStone() {

  		if (!_fixed){
  			setTarget(mouseX, mouseY);
  		} else {
  			stroke(255, 0, 0, _alpha);

  			ellipse(_centerPoint.x, _centerPoint.y, _mag, _mag);

  			stroke(0, _alpha);
  			line(_origin.x, _origin.y, _target.x, _target.y);
  		}
  	} 
} 