import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class HighlightsV1 extends PApplet {

ArrayList<Line> lineList = new ArrayList<Line>();

int intervall = 1,
	lastTime;
PVector target = new PVector(),
	origin = new PVector();


public void setup() {
  

  background(255);

  origin.set(width / 2, height / 2);

  lineList.add( new Line(origin));

  lastTime = millis();
}

public void draw() {
	background(255, 0);

	target.set(mouseX, mouseY);

	if (millis() > lastTime + intervall*1000){
		lastTime = millis();
		setLines();
	}

	for (Line aLine : lineList) {
		aLine.drawLine();
	}
}

public void setLines(){
	Line newestLine = lineList.get(lineList.size() - 1);
	newestLine.fix();

	lineList.add( new Line(newestLine._target));
}
class Line { 
  	PVector _origin,
  		_target;

  	boolean _fixed = false;
  	float _randomness = 45;
  	int _stepLimit = 50;

  	Line (PVector v) {  
  		_origin = v;
  		_randomness = random(-_randomness, _randomness);
  	}	

  	public void setTarget(float x, float y){

  		_target = new PVector(x,y);

  		PVector step = PVector.sub(_target, _origin);
  		step.limit(_stepLimit);
  		step.rotate(radians(_randomness));

  		_target = PVector.add(_origin, step);
  	}

  	public void fix(){
  		_fixed = true;
  	}

  	public void drawLine() {

  		if (!_fixed){
  			setTarget(mouseX, mouseY);
  		}
  		line(_origin.x, _origin.y, _target.x, _target.y);
  	} 
} 
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HighlightsV1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
