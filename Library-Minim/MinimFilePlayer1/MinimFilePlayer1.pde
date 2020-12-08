// MinimFilePlayer1.pde
// 24 11 2020
// Gerard Paresys
// https://github.com/gerardparesys/Processing-examples
//
// OK Processing 3.5.4 + MacOS
// OK Processing 3.5.3 + Raspberry Pi OS (Raspbian 10 buster)
// OK Processing 3.5.3 + Windows
// with library minim
// with library controlP5
//
// Ouvre un fichier Audio 
//
// http://code.compartmental.net/minim/fileplayer_class_fileplayer.html
// http://code.compartmental.net/minim/audiooutput_class_audiooutput.html
// http://www.sojamo.com/libraries/controlP5/reference/controlP5/Slider.html
//
//    FilePlayer -> AudioOutput
// MonFilePlayer -> Sortie
// It's important that the file is the same audio format 
// as our output (i.e. same sample rate, number of channels, etc).

//
// Bug minim: setBalance = setPan with a stereo sound file
// Bug minim: setBalance and setPan do not work with a mono sound file
//

import ddf.minim.*;
import ddf.minim.ugens.*;
import controlP5.*;

// String NomFichierAudio = "Goch-Dwa-CreoleHaitien.mp3";// Minim.STEREOO line 49
//String NomFichierAudio = "Left-Right-Mono.wav"; // Minim.MONO line 50
String NomFichierAudio = "Left-Right.wav"; // Minim.STEREOO line 50

color Green = color(0, 255, 0);

// AudioPlayer MonPlayer;
Minim MonMinim;
FilePlayer MonFilePlayer;
AudioOutput Sortie;

ControlP5 Moncp5;

void setup() {
  size(640, 360);
  noStroke();
  textSize(16);
  fill(Green);

  MonMinim = new Minim(this);
  MonFilePlayer = new FilePlayer(MonMinim.loadFileStream(NomFichierAudio));
  Sortie = MonMinim.getLineOut(Minim.STEREO); // Minim.MONO  Minim.STEREO
  MonFilePlayer.patch(Sortie); // patch the file player to the output

  Moncp5 = new ControlP5(this);

  Moncp5.addSlider("SliderBalance")
    .setPosition(180, 180)
    .setSize(400, 15)
    .setLabel("Balance")
    .setColorLabel(Green)
    .setColorForeground(255)
    .setColorBackground(Green)
    .setColorValue(Green)
    .setRange(-100, 100)
    .setNumberOfTickMarks(51)
    .setColorTickMark(Green)
    ;
  Moncp5.getController("SliderBalance").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  Moncp5.getController("SliderBalance").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);

  Moncp5.addSlider("SliderPan")
    .setPosition(180, 220)
    .setSize(400, 15)
    .setLabel("Pan")
    .setColorLabel(Green)
    .setColorForeground(255)
    .setColorBackground(Green)
    .setColorValue(Green)
    .setRange(-100, 100)
    .setNumberOfTickMarks(51)
    .setColorTickMark(Green)
    ;
  Moncp5.getController("SliderPan").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  Moncp5.getController("SliderPan").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);

  Moncp5.addSlider("SliderGain")
    .setPosition(180, 260)
    .setSize(400, 15)
    .setLabel("Gain dB")
    .setColorLabel(Green)
    .setColorForeground(255)
    .setColorBackground(Green)
    .setColorValue(Green)
    .setRange(-80, 20)
    .setNumberOfTickMarks(51)
    .setColorTickMark(Green)
    ;
  Moncp5.getController("SliderGain").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  Moncp5.getController("SliderGain").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);
}

void draw() {
  background(0);
  text("Open: " + NomFichierAudio, 20, 30);
  text(float(int((MonFilePlayer.position())/100.0)) / 10 + " sec", 560, 50);
  text(MonFilePlayer.channelCount() + " channels   " + int(MonFilePlayer.sampleRate()) + " Hz   "+ float(int((MonFilePlayer.length())/100.0)) / 10 + " sec", 20, 50);
  text("P: Play", 100, 80);
  text("S: Stop", 100, 100);
  text("L: Loop", 100, 120);
  text("R: Loop Random", 100, 140);
  text("esc: Quit", 100, 160);
  text("library minim: FilePlayer", 20, 350);
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    if (!MonFilePlayer.isPlaying()) MonFilePlayer.rewind();
    MonFilePlayer.setLoopPoints(0, MonFilePlayer.length());
    MonFilePlayer.play();
  }
  if (key == 's' || key == 'S') MonFilePlayer.pause();
  if (key == 'l' || key == 'L') MonFilePlayer.loop();
  if (key == 'r' || key == 'R') {
    int hasard1 = int(random(MonFilePlayer.length()));
    int hasard2 = int(random(hasard1, MonFilePlayer.length()));
    MonFilePlayer.setLoopPoints(hasard1, hasard2);
  }
}

void SliderBalance(int Bal) { // Bal = -100 .. 100
  Sortie.setBalance(Bal/100.0);
}

void SliderPan(int Pano) { // Pano = -100 .. 100
  Sortie.setPan(Pano/100.0);
}

void SliderGain(int G) { // G = -80dB .. +20dB
  Sortie.setGain(G);
}
