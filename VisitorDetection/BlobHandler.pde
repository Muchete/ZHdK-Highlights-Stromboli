class BlobHandler {
	
	public color trackColor = color(150, 50, 50);
	int blobCounter = 0;

	int maxLife = 50;

	public float threshold = 40;
	public float distThreshold = 50;

	public ArrayList<Blob> blobs = new ArrayList<Blob>();


	BlobHandler() {

	}

	void update(PImage image) {

		ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

	    // Begin loop to walk through every pixel
	    for (int x = 0; x < image.width; x++ ) {
	        for (int y = 0; y < image.height; y++ ) {
	            int loc = x + y * image.width;
	            // What is current color
	            color currentColor = image.pixels[loc];
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
	                    Blob b = new Blob(x, y, this);
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
	}

	//helper functions for color comparison
	private float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
        float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
        return d;
    }
}