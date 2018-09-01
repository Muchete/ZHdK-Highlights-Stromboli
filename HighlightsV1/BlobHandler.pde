class BlobHandler {

	public color trackColor = color(150, 50, 50);
	int blobCounter = 0;

	int maxLife = 50;
	int minSize = 2000;

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

				if (d < threshold * threshold) {

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

		for (int i = currentBlobs.size() - 1; i >= 0; i--) {
			if (currentBlobs.get(i).size() < minSize) {
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

	ArrayList<PVector> activeBlobs(PVector center, int inner, int outer) {

		ArrayList<PVector> activeBlobs = new ArrayList<PVector>();

		for (Blob b : blobs) {
			float distance = PVector.dist(b.getCenter(), center);
<<<<<<< HEAD
	        if (distance > inner && distance < outer) {
	        	PVector mappedCoordinates = b.getCenter().copy();

            mappedCoordinates.x = ((640 - mappedCoordinates.x) - center.x) / 200 * radius;
            mappedCoordinates.y = ((480 - mappedCoordinates.y) - center.y) / 200 * radius;
            
            if (mappedCoordinates.mag() > radius){
              mappedCoordinates = mappedCoordinates.normalize().mult(radius); 
            }
            
            mappedCoordinates.add(ultimateOrigin);
            mappedCoordinates.z = 0;

            //println("mappedCoordinates: "+mappedCoordinates);

	        	//println("mappedCoordinates: "+mappedCoordinates);
            //println("ultimateOrigin: "+ultimateOrigin);
	        	//println("radius: "+radius);
	        	//println("distance to ultimateOrigin: " + PVector.dist(mappedCoordinates, ultimateOrigin));

	        	//mappedCoordinates = mappedCoordinates.div(420).mult(radius * 2);

	        	activeBlobs.add(mappedCoordinates);
	        }
	    }
	    return activeBlobs;
=======
			if (distance > inner && distance < outer) {
				PVector mappedCoordinates = b.getCenter().copy();

				mappedCoordinates.x = ((640 - mappedCoordinates.x) - center.x) / 200 * radius;
				mappedCoordinates.y = ((480 - mappedCoordinates.y) - center.y) / 200 * radius;

				if (mappedCoordinates.mag() > radius) {
					mappedCoordinates = mappedCoordinates.normalize().mult(radius);
				}

				mappedCoordinates.add(ultimateOrigin);
				mappedCoordinates.z = 0;

				println("mappedCoordinates: " + mappedCoordinates);

				//println("mappedCoordinates: "+mappedCoordinates);
				//println("ultimateOrigin: "+ultimateOrigin);
				println("radius: " + radius);
				println("distance to ultimateOrigin: " + PVector.dist(mappedCoordinates, ultimateOrigin));

				//mappedCoordinates = mappedCoordinates.div(420).mult(radius * 2);

				activeBlobs.add(mappedCoordinates);
			}
		}
		return activeBlobs;
>>>>>>> dc9cf25f2aaac38f642c7ed67597686cc8736f42
	}

	//helper functions for color comparison
	private float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
		float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1);
		return d;
	}
}
