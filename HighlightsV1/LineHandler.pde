class LineHandler {

	//SETTINGS:

	//REQUIREMENTS
	PVector origin;
	int targetAmount = 0;
	ArrayList<StoneLine> allLines = new ArrayList<StoneLine>();

	LineHandler (PVector o) {
		origin = o;
	}

	void update(ArrayList<PVector> targets) {

		//check for changes in arraylist.
		//if yes, reassign targets
		updateLineTargets();

		drawMappingFields();

		//update and draw all stonelines
		for (StoneLine aLine : allLines) {
			aLine.update(targets); //update with the assigned target
		}
	}

	void drawMappingFields() {

		background(255);

		//draw mapping fields
		noStroke();
		
		fill(0);
		rectMode(CORNER);
		rect(10, 10, 2 * x_size + 2 * y_size, z_size);

		ellipseMode(CORNER);
		ellipse(10, 10 + z_size + 10, radius * 2, radius * 2);
		fill(255);
		rectMode(CENTER);
		rect(10 + radius, 10 + z_size + 10 + radius, x_size, y_size);

		ellipseMode(CORNER);
		stroke(0);
		noFill();
		ellipse(10 + 2 * radius + 10, 10 + z_size + 10, radius * 2, radius * 2);
		fill(0);
		noStroke();
		rectMode(CENTER);
		rect(10 + 3 * radius + 10, 10 + z_size + 10 + radius, x_size, y_size);
	}

	void updateLineTargets() {
		//if more or less targets then before, reassign targets
		if (targetAmount != allTargets.size()) {
			targetAmount = allTargets.size();

			//if more targets, create new line, else reassign
			if (allTargets.size() > allLines.size()) {
				allLines.add(new StoneLine(origin, allTargets.size() - 1));
			} else {
				reAssignTargets();
			}
		}
	}

	void addLine() {

		if (allLines.size() == 0) {
			allLines.add(new StoneLine(origin, allTargets.size() - 1));
		} else {

			PVector newTarget = allTargets.get(allTargets.size() - 1);

			float firstDistance = PVector.dist(newTarget, origin);
			float closestDistance = firstDistance;
			int closestBranchLine = 0;
			int stoneIndex = 0;

			for (int l = 0; l < allLines.size(); ++l) {
				StoneLine thisLine = allLines.get(l);

				//loop through all stones in stonelist
				float closestBranchDist = PVector.dist(thisLine.stoneList.get(0)._target, newTarget);

				for (int s = 1; s < thisLine.stoneList.size() - 1; ++s) {
					float newDist = PVector.dist(thisLine.stoneList.get(s)._target, newTarget);
					if (newDist < closestBranchDist) {
						closestBranchDist = newDist;
						stoneIndex = s;
						closestBranchLine = l;
					}
				}
			}

			float bestStoneDist = PVector.dist(allLines.get(closestBranchLine).stoneList.get(stoneIndex)._target, newTarget);

			if (bestStoneDist < PVector.dist(newTarget, origin)) {
				println("DOING BRANCH!");
				createBranch(closestBranchLine, stoneIndex, allTargets.size() - 1);
			} else {
				allLines.add(new StoneLine(origin, allTargets.size() - 1));
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

			float firstDistance = PVector.dist(thisTarget, origin);
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

			if (PVector.dist(allLines.get(closestLine).newestStone._target, thisTarget) <= firstDistance) {
				assignTarget(closestLine, t);
			} else {

				//if origin was closer, create new line
				allLines.add(new StoneLine(origin, t));
			}
		}
	}

	void assignTarget(int l, int t) {
		allLines.get(l).assignId(t);
		allLines.get(l).active = true;
	}
}