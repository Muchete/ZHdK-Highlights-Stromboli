class SoundHandler {
	
	//SETTINGS
	String[] filenames = { "sample1.wav", "sample1.wav", "sample1.wav" };

	//REQUIREMENTS
	ArrayList<AudioPlayer> playerList = new ArrayList<AudioPlayer>();

	SoundHandler () {
		//load all samples defined above
		for (int n = 0; n < filenames.length; ++n) {
			loadSample(filenames[n]);
		}
	}

	void loadSample(String name){
		AudioPlayer player;
		player = m.loadFile("data/sounds/" + name);
		playerList.add(player);
		println("added Sample: " + name);
	}

	void play(){
	}

	void playRandom(){
		int randomNo = int(random(filenames.length));
		println(randomNo);
		playerList.get(randomNo).rewind();
		playerList.get(randomNo).play();
	}

	void pauseAll(){
		for (AudioPlayer p : playerList) {
			p.pause();
			p.rewind();
		}
	}
}