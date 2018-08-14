import org.openkinect.processing.*;

Kinect kinect;

int blobCounter = 0;

int maxLife = 50;

color trackColor; 
float threshold = 40;
float distThreshold = 50;

ArrayList<Blob> blobs = new ArrayList<Blob>();

int lowerThreshold = 0;
int upperThreshold = 900;

void setup() {
  size(640, 480);

  kinect = new Kinect(this);
  kinect.initDepth();

  trackColor = color(150, 50, 50);
}

void draw() {
  PImage img = kinect.getDepthImage();

  PImage result = new PImage(640, 480);

  int[] depthMap = kinect.getRawDepth();

  result.loadPixels();

  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {
      int loc = x+ y * 640;
      int rawDepth = depthMap[loc];
      
      if (rawDepth > lowerThreshold && rawDepth < upperThreshold) {
        result.pixels[loc] = color(150, 50, 50);
      } else {
        result.pixels[loc] = img.pixels[loc];
      }
    }
  }

  result.updatePixels();

  image(result, 0, 0);

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

  // Begin loop to walk through every pixel
  for (int x = 0; x < result.width; x++ ) {
    for (int y = 0; y < result.height; y++ ) {
      int loc = x + y * result.width;
      // What is current color
      color currentColor = result.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
        }
      }
    }
  }

  for (int i = currentBlobs.size()-1; i >= 0; i--) {
    if (currentBlobs.get(i).size() < 2000) {
      currentBlobs.remove(i);
    }
  }

  // There are no blobs!
  if (blobs.isEmpty() && currentBlobs.size() > 0) {
    println("Adding blobs!");
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    // Match whatever blobs you can match
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d; 
          matched = cb;
        }
      }
      matched.taken = true;
      b.become(matched);
    }

    // Whatever is leftover make new blobs
    for (Blob b : currentBlobs) {
      if (!b.taken) {
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    }


    // Match whatever blobs you can match
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) {
          recordD = d; 
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.lifespan = maxLife;
        matched.become(cb);
      }
    }

    for (int i = blobs.size() - 1; i >= 0; i--) {
      Blob b = blobs.get(i);
      if (!b.taken) {
        if (b.checkLife()) {
          blobs.remove(i);
        }
      }
    }
  }

  boolean touched = false;
  int size = int(height * 0.75);

  for (Blob b : blobs) {
    b.show();
    if (PVector.dist(b.getCenter(), new PVector(width/2, height/2)) < size/2) {
        touched = true;
    }
  } 


  noFill();
  if (touched) {
    stroke(0, 255, 0);  
  } else {
    stroke(255, 0, 0);
  }
  ellipse(width / 2, height / 2, size, size);



  textAlign(RIGHT);
  fill(0);
  //text(currentBlobs.size(), width-10, 40);
  //text(blobs.size(), width-10, 80);
  textSize(24);
  text("color threshold: " + threshold, width-10, 50);  
  text("distance threshold: " + distThreshold, width-10, 25);

}

void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    distThreshold-=5;
  }
  if (key == 's') {
    threshold+=5;
  } else if (key == 'x') {
    threshold-=5;
  }

  if (key == CODED) {
    if (keyCode == UP) {
      upperThreshold += 1;
    } else if (keyCode == DOWN) {
      upperThreshold -= 1;
    }
  }
  println(upperThreshold);
}


float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

