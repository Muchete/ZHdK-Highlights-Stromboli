class LineHandler {

	//SETTINGS:

	//REQUIREMENTS
	int targetAmount = 0;
	ArrayList<StoneLine> allLines = new ArrayList<StoneLine>();

	LineHandler () {

		loadGraphics();

	}

	void loadGraphics() {
		graphics = new PImage[imageCount]; //set amount of images
		for (int i = 0; i < imageCount; ++i) {
			graphics[i] = loadImage("img/stone-0" + (i + 2) + ".png");
		}
	}

	void update(ArrayList<PVector> targets) {

		//remove empty lines:
		removeEmptyLines();

		//check for changes in arraylist.
		//if yes, reassign targets
		updateLineTargets();

		//creating background for the mapping images
		drawMappingFields();

		//update and draw all stonelines
		for (StoneLine aLine : allLines) {
			aLine.update(targets); //update with the assigned target
		}
	}

	void drawMappingFields() {

		background(0);

		//draw mapping fields
		noStroke();

		fill(255);
		rectMode(CORNER);
		rect(offset, offset, 2 * x_size + 2 * y_size, z_size);

		stroke(0);
		//line(offset + y_size, offset, offset + y_size, offset + z_size);
		//line(offset + y_size + x_size, offset, offset + y_size + x_size, offset + z_size);
		//line(offset + y_size + x_size + y_size, offset, offset + y_size + x_size + y_size, offset + z_size);

		ellipseMode(CORNER);
		ellipse(offset, offset + z_size + offset, radius * 2, radius * 2);
		fill(0);
		rectMode(CENTER);
		rect(offset + radius, offset + z_size + offset + radius, x_size, y_size);

		ellipseMode(CORNER);
		stroke(255);
		noFill();
		ellipse(offset + 2 * radius + offset, offset + z_size + offset, radius * 2, radius * 2);
		fill(255);
		noStroke();
		rectMode(CENTER);
		rect(offset + 3 * radius + offset, offset + z_size + offset + radius, x_size, y_size);


		if (debugMode){
			//draw targets
			pushMatrix();
			translate(-ultimateOrigin.x, -ultimateOrigin.y);
			translate(offset + radius, offset + z_size + offset + radius);
			noStroke();
			for (PVector v : allTargets) {
				noStroke();
				fill(255, 0, 0);
				ellipse(v.x, v.y, 25, 25);
			}
			popMatrix();

			//draw stone pos
			pushMatrix();
			translate(-ultimateOrigin.x, -ultimateOrigin.y);
			translate(offset + 3 * radius + offset, offset + z_size + offset + radius);
			fill(0, 255, 0);
			ellipse(stoneOrigin.x, stoneOrigin.y, 25, 25);
			popMatrix();
		}
	}

	void removeEmptyLines() {
		//check all lines
		for (int l = 0; l < allLines.size(); ++l) {
			//if line empty remove
			if (allLines.get(l).empty) {
				//if line was branch, search for branched stone and mark as unbranched
				if (allLines.get(l).isBranchLine) {
					//find correlating line with branchstone
					int otherBranches = 0;
					StoneLine thisBranchLine = allLines.get(l);
					Stone thisBranchStone = null; //initialize

					//find branched mother stone from the other line
					for (int bl = 0; bl < allLines.size(); ++bl) {
						for (int s = 0; s < allLines.get(bl).stoneList.size(); ++s) {
							Stone thisStone = allLines.get(bl).stoneList.get(s);

							if (thisStone._target == thisBranchLine._origin && thisStone.isBranchStone) {
								thisBranchStone = thisStone;
							}
						}
					}

					//check if branched stone has only one branch
					for (int ol = 0; ol < allLines.size(); ++ol) {
						if (allLines.get(ol).isBranchLine) {
							if (thisBranchStone._target == allLines.get(ol)._origin) {
								otherBranches++;
							}
						}
					}

					//if only one branch was created from this stone, remove decay-block
					if (otherBranches == 1) {
						thisBranchStone.isBranchStone = false;
					}
				}

				allLines.remove(l);
			}
		}
	}

	void updateLineTargets() {
		//if more or less targets then before, reassign targets

		if (targetAmount > allTargets.size()) {
		  targetAmount = allTargets.size();
    } else if (targetAmount < allTargets.size()){
      targetAmount = allTargets.size();
      soundHandler.playRandom();
    }

		//if more targets, create new line, else reassign
		if (allTargets.size() > allLines.size()) {
			addLine();
		} else {
			reAssignTargets();
		}
		// }
	}

	void addLine() {

		if (allLines.size() == 0) {
			allLines.add(new StoneLine(stoneOrigin, allTargets.size() - 1));
		} else {

			PVector newTarget = allTargets.get(allTargets.size() - 1);

			float firstDistance = PVector.dist(newTarget, stoneOrigin);
			float closestDistance = firstDistance;
			int closestBranchLine = 0;
			int stoneIndex = 0;

			for (int l = 0; l < allLines.size(); ++l) {
				StoneLine thisLine = allLines.get(l);

				//loop through all stones in stonelist
				float closestBranchDist = PVector.dist(thisLine.stoneList.get(0)._target, newTarget);

				for (int s = 1; s < thisLine.stoneList.size() - 1; ++s) {
					float newDist = PVector.dist(thisLine.stoneList.get(s)._target, newTarget);
					if (newDist < closestBranchDist && !thisLine.stoneList.get(s).dead) {
						closestBranchDist = newDist;
						stoneIndex = s;
						closestBranchLine = l;
					}
				}
			}

			float bestStoneDist = PVector.dist(allLines.get(closestBranchLine).stoneList.get(stoneIndex)._target, newTarget);

			if (bestStoneDist < PVector.dist(newTarget, stoneOrigin)) {
				// println("DOING BRANCH!");
				createBranch(closestBranchLine, stoneIndex, allTargets.size() - 1);
			} else {
				allLines.add(new StoneLine(stoneOrigin, allTargets.size() - 1));
			}
		}
	}

	void createBranch(int branchIndex, int stoneIndex, int t) {

		PVector branchOrigin = allLines.get(branchIndex).stoneList.get(stoneIndex)._target;

		//set branch stone to branched:
		allLines.get(branchIndex).stoneList.get(stoneIndex).isBranchStone = true;

		StoneLine newLine = new StoneLine(branchOrigin, t);
		newLine.isBranchLine = true;

		allLines.add(newLine);
	}

	void branchKiller() {

	}

	void reAssignTargets() {

		// deactivate all lines
		for (StoneLine aLine : allLines) {
			aLine.deactivate();
		}

		// go through each target
		for (int t = 0; t < allTargets.size(); ++t) {
			PVector thisTarget = allTargets.get(t);

			float firstDistance = PVector.dist(thisTarget, stoneOrigin);
			float closestDistance = firstDistance;
			int closestLine = 0;


			// go through each line to find closest to sinlge target
			for (int l = 0; l < allLines.size(); ++l) {
				StoneLine thisLine = allLines.get(l);

				//only if no target is assigned yet check for distance to target
				if (!thisLine.active) {
					float thisDist = PVector.dist(thisLine.newestStone._target, thisTarget);
					if (thisDist < closestDistance) {
						closestDistance = thisDist;
						closestLine = l;
					}
				}
			}

			float bestLineDist = PVector.dist(allLines.get(closestLine).newestStone._target, thisTarget);

			if (bestLineDist <= firstDistance) {
				//if inactive line was close, assign new target
				assignTarget(closestLine, t);
			} else {
				//if origin was closer, create new line
				allLines.add(new StoneLine(stoneOrigin, t));
			}
		}
	}

	void assignTarget(int l, int t) {
		allLines.get(l).assignId(t);
		allLines.get(l).active = true;
	}
}
