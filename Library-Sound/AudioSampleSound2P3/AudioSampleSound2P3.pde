// AudioSampleSound2P3.pde
// 7-1-2018
//
// OK Processing 3.3.7 MacOS 
//
// Utilise la library sound 2.0.2
//
// https://processing.org/reference/libraries/sound/SoundFile.html
// https://processing.org/reference/libraries/sound/AudioSample.html
// https://github.com/processing/processing-sound/blob/master/src/processing/sound/AudioSample.java
// https://kevinstadler.github.io/processing-sound/docs/processing/sound/AudioSample.html

import processing.sound.*;

SoundFile FichierAudio;
AudioSample Sample1;
float[] TableauFichierAudio;

void setup() {
  size(640, 360);
  noStroke();
  FichierAudio = new SoundFile(this, "ONSBJ_anna.wav"); 
  //FichierAudio = new SoundFile(this, "ONSBJ_annaStereo.wav"); // ne fonctionne pas avec un fichier Stereo pourquoi?
  TableauFichierAudio = new float[FichierAudio.frames()];
  FichierAudio.read(0, TableauFichierAudio, 0, TableauFichierAudio.length);
  Sample1 = new AudioSample(this, TableauFichierAudio, false); // AudioSample(parent, data, stereo)
  // Sample1 = new AudioSample(this, TableauFichierAudio, true); // AudioSample(parent, data, stereo)

  println("Sample1.frames() = " + Sample1.frames());
  println("Sample1.channels() = " + Sample1.channels());
  println("Sample1.sampleRate() = " + Sample1.sampleRate());
  println("Sample1.duration() = " + Sample1.duration() + " sec");
  println("Sample1.isPlaying() = " + Sample1.isPlaying());
  println("----------------------------------");
}      


void draw() {
  background(0);
  textSize(16);
  fill(0, 255, 0);
  text("P: Play", 100, 100);
  text("S: Stop", 100, 120);
  text("L: Loop", 100, 140);
  text("A: Pause", 100, 160);
  text("I: Amplitude 0dB", 100, 180);
  text("K: Amplitude -20dB", 100, 200);
  text("J: Jump randomly", 100, 220);
  text("C: Cue randomly", 100, 240);
  text("Q: Cue = 0", 100, 260);
  text("R: Pano randomly", 100, 280);

  rect(0, height - 20, width * Sample1.percent() / 100.0, height);
}

void keyPressed() {
  if (key == 'p' || key == 'P') Sample1.play();
  if (key == 's' || key == 'S') Sample1.stop();
  if (key == 'l' || key == 'L') Sample1.loop();
  if (key == 'a' || key == 'A') Sample1.pause();
  if (key == 'k' || key == 'K') Sample1.amp(0.1);
  if (key == 'i' || key == 'I') Sample1.amp(1);
  if (key == 'j' || key == 'J') Sample1.jump(random(Sample1.duration()));
  if (key == 'c' || key == 'C') Sample1.cue(random(Sample1.duration())); // en secondes
  if (key == 'q' || key == 'Q') Sample1.cue(0); // en secondes
  if (key == 'r' || key == 'R') Sample1.pan(random(-1, 1));
  // if (key == 'z' || key == 'Z') Sample1.write(TableauFichierAudio); // RAZ
  ;

  println("Sample1.isPlaying() = " + Sample1.isPlaying());
  println("Sample1.percent() = " + Sample1.percent());
  println("Sample1.position() = " + Sample1.position());
}
