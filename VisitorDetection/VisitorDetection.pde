import org.openkinect.processing.*;

Kinect kinect;

BlobHandler blobHandler;

boolean touched = false;
int radius;

int lowerThreshold = 0;
int upperThreshold = 900;

ArrayList<PVector> allTargets = new ArrayList<PVector>();
PVector centerPoint;

void setup() {
    size(640, 480);

    kinect = new Kinect(this);
    kinect.initDepth();

    blobHandler = new BlobHandler();

    radius = int(height * 0.75);

    centerPoint = new PVector(width/2, height/2);
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
    allTargets = blobHandler.activeBlobs(centerPoint, 100, 150);

    for (Blob b : blobHandler.blobs) {
        b.show();
    } 


    stroke(0, 255, 0);
    noFill(); 
    ellipse(centerPoint.x, centerPoint.y, 150, 150);

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

void mouseClicked() {
    centerPoint = new PVector(mouseX, mouseY);
}
