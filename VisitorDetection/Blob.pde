class Blob {
    float minx;
    float miny;
    float maxx;
    float maxy;

    int id = 0;

    BlobHandler handler;

    int lifespan;
    int maxLife;
    int distThreshold;

    boolean taken = false;

    Blob(float x, float y, BlobHandler handler) {
        minx = x;
        miny = y;
        maxx = x;
        maxy = y;
        this.handler = handler;

        lifespan = handler.maxLife;
    }

    boolean checkLife() {
        lifespan--; 
        if (lifespan < 0) {
            return true;
        } else {
            return false;
        }
    }

    void show() {
        stroke(0);
        fill(255, lifespan);
        strokeWeight(2);
        rectMode(CORNERS);
        rect(minx, miny, maxx, maxy);

        textAlign(CENTER);
        textSize(64);
        fill(0);
        text(id, minx + (maxx-minx)*0.5, maxy - 10);
        textSize(32);

        // rectMode(CENTER);
        // fill(255, 0, 0);
        // rect(minx + (minx + maxx)/2, miny + (miny + maxy)/2, 10, 10);

        //text(lifespan, minx + (maxx-minx)*0.5, miny - 10);
    }


    void add(float x, float y) {
        minx = min(minx, x);
        miny = min(miny, y);
        maxx = max(maxx, x);
        maxy = max(maxy, y);
    }

    void become(Blob other) {
        minx = other.minx;
        maxx = other.maxx;
        miny = other.miny;
        maxy = other.maxy;
        lifespan = handler.maxLife;
    }

    float size() {
        return (maxx-minx)*(maxy-miny);
    }

    PVector getCenter() {
        float x = (maxx - minx)* 0.5 + minx;
        float y = (maxy - miny)* 0.5 + miny;    
        return new PVector(x, y);
    }

    boolean isNear(float x, float y) {

        float cx = max(min(x, maxx), minx);
        float cy = max(min(y, maxy), miny);
        float d = distSq(cx, cy, x, y);

        if (d < handler.distThreshold*handler.distThreshold) {
            return true;
        } else {
            return false;
        }
    }

    //helper functions for color comparison
    private float distSq(float x1, float y1, float x2, float y2) {
        float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
        return d;
    }
}

