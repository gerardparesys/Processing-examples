// MinimAudioSample1.pde
// 25 11 2020
// Gerard Paresys
// https://github.com/gerardparesys/Processing-examples
//
// OK Processing 3.5.4 + MacOS
// OK Processing 3.5.3 + Raspberry Pi OS (Raspbian 10 buster)
// OK Processing 3.5.3 + Windows
// with library minim
// with library controlP5
//
// Open and Play an audio file 
//
// http://code.compartmental.net/minim/audiosample_class_audiosample.html
// http://www.sojamo.com/libraries/controlP5/reference/controlP5/Slider.html
// 
// Bug minim: setBalance = setPan with a stereo sound file
// Bug minim: setBalance and setPan do not work with a mono sound file
//

import ddf.minim.*;
import controlP5.*;

// String NomFichierAudio = "Goch-Dwa-CreoleHaitien.mp3";
// String NomFichierAudio = "Left-Right-Mono.wav";
String NomFichierAudio = "Left-Right.wav";

color Green = color(0, 255, 0);

AudioSample MonAudioSample;
Minim MonMinim;
ControlP5 Moncp5;

void setup() {
  size(640, 360);
  noStroke();
  textSize(16);
  fill(Green);

  MonMinim = new Minim(this);
  MonAudioSample = MonMinim.loadSample(NomFichierAudio, 512);

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
    .setValue(0)
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
    .setValue(0)
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
    .setValue(0)
    ;
  Moncp5.getController("SliderGain").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  Moncp5.getController("SliderGain").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);
}

void draw() {
  background(0);
  text("Open: " + NomFichierAudio, 20, 30);
  text(MonAudioSample.getFormat().getChannels() + " channels   " + int(MonAudioSample.getFormat().getSampleRate()) + " Hz   " + MonAudioSample.getFormat().getSampleSizeInBits() + " bits   " + float(int((MonAudioSample.length())/100.0)) / 10 + " sec", 20, 50);
  text("P: Play", 100, 80);
  text("S: Stop", 100, 100);
  text("esc: Quit", 100, 160);
  text("library minim: AudioSample", 20, 350);
}

void keyPressed() {
  if (key == 'p' || key == 'P') MonAudioSample.trigger();
  if (key == 's' || key == 'S') MonAudioSample.stop();
}

void SliderBalance(int Bal) {
  MonAudioSample.setBalance(Bal/100.0);
}

void SliderPan(int Pano) {
  MonAudioSample.setPan(Pano/100.0);
}

void SliderGain(int G) {
  MonAudioSample.setGain(G);
}
