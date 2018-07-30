class Line { 

	//SETTINGS:

	float _randomness = 45;
  	int _stepLimit = 30;

  	//REQUIREMENTS

  	PVector _origin, _target;
  	boolean _fixed = false;

  	Line (PVector v) {  
  		_origin = v;
  		_randomness = random(-_randomness, _randomness);
  	}	

  	void setTarget(float x, float y){

  		_target = new PVector(x,y);

  		PVector step = PVector.sub(_target, _origin);
  		step.limit(_stepLimit);
  		step.rotate(radians(_randomness));

  		_target = PVector.add(_origin, step);
  	}

  	void fix(){
  		_fixed = true;
  	}

  	void drawLine() {

  		if (!_fixed){
  			setTarget(mouseX, mouseY);
  		} else {
  			line(_origin.x, _origin.y, _target.x, _target.y);
  		}
  	} 
} 