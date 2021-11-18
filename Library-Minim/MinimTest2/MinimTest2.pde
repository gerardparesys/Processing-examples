// MinimTest2.pde
//
// 18 11 2021
// Gerard Paresys
// https://github.com/gerardparesys/Processing-examples
//
// OK Processing 3.5.4 + MacOS
// OK Processing 3.5.3 + Raspberry Pi OS (Raspbian 10 buster)
// OK Processing 3.5.3 + Ubuntu
// OK Processing 3.5.4 + Windows10
// Not compatible with Processing 2
// with library minim
//
// Open an Audio file
//
// http://code.compartmental.net/minim/fileplayer_class_fileplayer.html
// http://code.compartmental.net/minim/audiooutput_class_audiooutput.html
//
//    FilePlayer -> AudioOutput
// MonFilePlayer -> Sortie
// It's important that the file is the same audio format 
// as our output (i.e. same sample rate, number of channels, etc).
//
// getGain() max = +6.0206 dB
// getGain() min =     -80 dB
// 
// A normalized signal saturates at + 6dB
//

import ddf.minim.*;
import ddf.minim.ugens.*;

String NomFichierAudio = "Goch-Dwa-CreoleHaitien.mp3";
// String NomFichierAudio = "Left-Right.wav"; 

color Green = color(0, 255, 0);

// AudioPlayer MonPlayer;
Minim MonMinim;
FilePlayer MonFilePlayer;
AudioOutput Sortie;


void setup() {
  size(640, 360);
  background(0);
  textAlign(CENTER);
  textSize(32);
  fill(Green);
  stroke(Green);

  MonMinim = new Minim(this);
  MonFilePlayer = new FilePlayer(MonMinim.loadFileStream(NomFichierAudio));
  Sortie = MonMinim.getLineOut(Minim.STEREO); // Minim.MONO  Minim.STEREO
  MonFilePlayer.patch(Sortie); // patch the file player to the output
  
  Sortie.printControls();

  line (width / 4, 0, width / 4, height);
  line (width / 2, 0, width / 2, height);
  line (3 * width / 4, 0, 3 * width / 4, height);
  line (0, height / 4, width / 2, height / 4);
  line (0, height / 2, width / 2, height / 2);
  line (0, 3 * height / 4, width / 2, 3 * height / 4);

  text("Play", width / 8, 40);
  text("6dB", width / 8, 80);
  text("(P)lay", width / 8, height / 4 + 40);
  text("0dB", width / 8, height / 4 + 80);
  text("Play", width / 8, height / 2 + 40);
  text("-10dB", width / 8, height / 2 + 80);
  text("Play", width / 8, 3 * height / 4 + 40);
  text("-20dB", width / 8, 3 * height / 4 + 80);

  text("Loop", 3 * width / 8, 40);
  text("6dB", 3 * width / 8, 80);
  text("(L)oop", 3 * width / 8, height / 4 + 40);
  text("0dB", 3 * width / 8, height / 4 + 80);
  text("Loop", 3 * width / 8, height / 2 + 40);
  text("-10dB", 3 * width / 8, height / 2 + 80);
  text("Loop", 3 * width / 8, 3 * height / 4 + 40);
  text("-20dB", 3 * width / 8, 3 * height / 4 + 80);

  text("(S)top", 5 * width / 8, height / 2);
  text("Quit", 7 * width / 8, height / 2);
  text("(esc)", 7 * width / 8, height / 2 + 40);
}

void draw() {
}

void mousePressed() {
  int X = (4 * mouseX) / width;
  int Y = (4 * mouseY) / height;
  if (X == 0) {
    if (Y == 0) Sortie.setGain(6);
    if (Y == 1) Sortie.setGain(0);
    if (Y == 2) Sortie.setGain(-10);
    if (Y == 3) Sortie.setGain(-20);
    if (!MonFilePlayer.isPlaying()) MonFilePlayer.rewind();
    MonFilePlayer.play();
  }
  if (X == 1) {
    if (Y == 0) Sortie.setGain(6);
    if (Y == 1) Sortie.setGain(0);
    if (Y == 2) Sortie.setGain(-10);
    if (Y == 3) Sortie.setGain(-20);
    MonFilePlayer.loop();
  }
  if (X == 2) {
    Sortie.setGain(-100);
    MonFilePlayer.pause();
  }
  if (X == 3) exit();
  println("Sortie.getGain() = " + Sortie.getGain());
}

void keyPressed() {
  Sortie.setGain(0);
  if (key == 'p' || key == 'P') {
    Sortie.setGain(0);
    if (!MonFilePlayer.isPlaying()) MonFilePlayer.rewind();
    MonFilePlayer.play();
  }
  if (key == 's' || key == 'S') MonFilePlayer.pause();
  if (key == 'l' || key == 'L') MonFilePlayer.loop();
}
