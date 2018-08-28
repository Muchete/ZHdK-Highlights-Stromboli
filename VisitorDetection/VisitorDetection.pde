import org.openkinect.processing.*;

Kinect kinect;

BlobHandler blobHandler;

boolean touched = false;
int radius;

int lowerThreshold = 0;
int upperThreshold = 900;

void setup() {
    size(640, 480);

    kinect = new Kinect(this);
    kinect.initDepth();

    blobHandler = new BlobHandler();

    radius = int(height * 0.75);
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
                result.pixels[loc] = blobHandler.trackColor;
            } else {
                result.pixels[loc] = img.pixels[loc];
            }
        }
    }

    result.updatePixels();

    image(result, 0, 0);

    blobHandler.update(result);

    for (Blob b : blobHandler.blobs) {
        b.show();
        if (PVector.dist(b.getCenter(), new PVector(width/2, height/2)) < radius/2) {
                touched = true;
        }
    } 


    noFill();
    if (touched) {
        stroke(0, 255, 0);  
    } else {
        stroke(255, 0, 0);
    }
    ellipse(width / 2, height / 2, radius, radius);

}

void keyPressed() {
    if (key == 'a') {
        blobHandler.distThreshold+=5;
    } else if (key == 'z') {
        blobHandler.distThreshold-=5;
    }
    if (key == 's') {
        blobHandler.threshold+=5;
    } else if (key == 'x') {
        blobHandler.threshold-=5;
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

