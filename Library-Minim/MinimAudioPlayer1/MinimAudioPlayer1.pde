// MinimAudioPlayer1.pde
// 23 11 2020
// Gerard Paresys
//
// OK Processing 3.5.4 + MacOS
// OK Processing 3.5.3 + Raspberry Pi OS (Raspbian 10 buster)
// OK Processing 3.5.3 + Windows
// with library minim
// with library controlP5
//
// Ouvre un fichier Audio 
//
// http://code.compartmental.net/minim/audioplayer_class_audioplayer.html
// http://www.sojamo.com/libraries/controlP5/reference/controlP5/Slider.html
// 
// Bug minim: setBalance = setPan
//

import ddf.minim.*;
import controlP5.*;

// String NomFichierAudio = "Goch-Dwa-CreoleHaitien.mp3";
String NomFichierAudio = "Left-Right.wav";

color Green = color(0, 255, 0);

AudioPlayer MonPlayer;
Minim MonMinim;
ControlP5 cp5;

void setup() {
  size(640, 360);
  noStroke();
  textSize(16);
  fill(Green);

  MonMinim = new Minim(this);  // create our Minim object for loading audio
  MonPlayer = MonMinim.loadFile(NomFichierAudio, 1024);

  cp5 = new ControlP5(this);

  cp5.addSlider("SliderBalance")
    .setPosition(180, 160)
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
  cp5.getController("SliderBalance").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  cp5.getController("SliderBalance").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);

  cp5.addSlider("SliderPan")
    .setPosition(180, 200)
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
  cp5.getController("SliderPan").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  cp5.getController("SliderPan").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);

  cp5.addSlider("SliderGain")
    .setPosition(180, 240)
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
  cp5.getController("SliderGain").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  cp5.getController("SliderGain").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);
}

void draw() {
  background(0);
  text("Open: " + NomFichierAudio, 20, 30);
  // text(MonPlayer.getFormat().getChannels() + " channels   " + int(MonPlayer.getFormat().getSampleRate()) + " Hz   " + MonPlayer.getFormat().getSampleSizeInBits() + " bits   " + MonPlayer.length() + " s", 20, 50);
  text(float(int((MonPlayer.position())/100.0)) / 10 + " sec", 560, 50);
  text(MonPlayer.getFormat().getChannels() + " channels   " + int(MonPlayer.getFormat().getSampleRate()) + " Hz   " + MonPlayer.getFormat().getSampleSizeInBits() + " bits   " + float(int((MonPlayer.length())/100.0)) / 10 + " sec", 20, 50);
  text("P: Play", 100, 80);
  text("S: Stop", 100, 100);
  text("L: Loop", 100, 120);
  text("esc: Quit", 100, 140);
  text("library minim: audioplayer", 20, 350);
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    if (!MonPlayer.isPlaying()) MonPlayer.rewind();
    MonPlayer.play();
  }
  if (key == 's' || key == 'S') MonPlayer.pause();
  if (key == 'l' || key == 'L') MonPlayer.loop();
}

void SliderBalance(int Bal) {
  MonPlayer.setBalance(Bal/100.0);
  println("Balance = " + Bal);
}

void SliderPan(int Pano) {
  MonPlayer.setPan(Pano/100.0);
  println("Pan = " + Pano);
}

void SliderGain(int G) {
  MonPlayer.setGain(G);
  println("Gain = " + G);
}
