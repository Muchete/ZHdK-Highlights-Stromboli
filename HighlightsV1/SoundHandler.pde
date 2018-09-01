class SoundHandler {
	
	//SETTINGS
	String[] filenames = { "sample1.2.wav", "sample1.2.wav", "sample1.2.wav" };
  float soundPeriod = 15; //in seconds

	//REQUIREMENTS
	ArrayList<AudioPlayer> playerList = new ArrayList<AudioPlayer>();
  boolean readyForSound = true;
  int lastSound;

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

	void update(){
    if (millis() > lastSound + 1000 * soundPeriod){
      readyForSound = true;
    }
	}

	void playRandom(){
    if (readyForSound){
      println("played sound");
  		int randomNo = int(random(filenames.length));
  		playerList.get(randomNo).rewind();
  		playerList.get(randomNo).play();
      readyForSound = false;
      lastSound = millis();
    }
	}

	void pauseAll(){
		for (AudioPlayer p : playerList) {
			p.pause();
			p.rewind();
		}
	}
}
