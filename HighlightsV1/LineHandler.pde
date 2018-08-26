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

		//update and draw all stonelines
		for (StoneLine aLine : allLines) {
			aLine.update(targets); //update with the assigned target
		}
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
				allLines.add(new StoneLine(origin, t));
			}
		}
	}

	void assignTarget(int l, int t) {
		allLines.get(l).assignId(t);
		allLines.get(l).active = true;
	}
}