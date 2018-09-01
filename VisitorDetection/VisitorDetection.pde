import org.openkinect.processing.*;

Kinect kinect;

BlobHandler blobHandler;

boolean touched = false;
int radius;
PVector _ultimateOrigins = new PVector(500, 500);

int lowerThreshold = 700;
int upperThreshold = 930;

ArrayList<PVector> allTargets = new ArrayList<PVector>();
PVector centerPoint;

void setup() {
    size(640, 480);

    kinect = new Kinect(this);
    kinect.initDepth();

    blobHandler = new BlobHandler();

    radius = 200;

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
    allTargets = blobHandler.activeBlobs(centerPoint, 100, 250);
    
    println(allTargets);

    for (PVector b : allTargets) {
        fill(0,0,255);
        ellipse(b.x, b.y, 20, 20);
    } 


    stroke(0, 255, 0);
    noFill();
    ellipse(centerPoint.x, centerPoint.y, 200, 200);
    ellipse(centerPoint.x, centerPoint.y, 500, 500);

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
            blobHandler.minSize += 1;
        } else if (keyCode == DOWN) {
            blobHandler.minSize -= 1;
        }
    }
    println(blobHandler.minSize);
}

void mouseClicked() {
    centerPoint = new PVector(mouseX, mouseY);
}
