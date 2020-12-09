// MinimSampler1.pde
// 9 12 2020
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
// http://code.compartmental.net/minim/sampler_class_sampler.html
// http://code.compartmental.net/minim/audiooutput_class_audiooutput.html
// http://www.sojamo.com/libraries/controlP5/reference/controlP5/Slider.html
//
//    Sampler -> AudioOutput
// MonSampler -> Sortie
//
// Bug minim: setBalance = setPan with a stereo sound file
// Bug minim: setBalance = setPan with a mono sound file
//

import ddf.minim.*;
import ddf.minim.ugens.*;
import controlP5.*;

//String NomFichierAudio = "Goch-Dwa-CreoleHaitien.mp3";// Minim.STEREO line 49
//int NbrEchantillonFichier = 45440;
//String NomFichierAudio = "Left-Right-Mono.wav"; 
String NomFichierAudio = "Left-Right.wav"; 
int NbrEchantillonFichier = 60990;

int maxVoices = 4; // the maximum number of voices for Sampler

color Green = color(0, 255, 0);

Minim MonMinim;
AudioOutput Sortie;
Sampler MonSampler;

ControlP5 Moncp5;

void setup() {
  size(640, 360);
  noStroke();
  textSize(16);
  fill(Green);

  MonMinim = new Minim(this);
  Sortie = MonMinim.getLineOut(Minim.STEREO); 
  MonSampler = new Sampler(NomFichierAudio, maxVoices, MonMinim);  
  MonSampler.patch(Sortie); // patch the Sampler to the output

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

  Moncp5.addSlider("SliderAmplitude")
    .setPosition(180, 260)
    .setSize(400, 15)
    .setLabel("Amplitude")
    .setColorLabel(Green)
    .setColorForeground(255)
    .setColorBackground(Green)
    .setColorValue(Green)
    .setRange(0, 200)
    .setNumberOfTickMarks(51)
    .setColorTickMark(Green)
    .setValue(100)
    ;
  Moncp5.getController("SliderAmplitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  Moncp5.getController("SliderAmplitude").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);

  Moncp5.addSlider("SliderAttack")
    .setPosition(180, 300)
    .setSize(400, 15)
    .setLabel("Attack ms")
    .setColorLabel(Green)
    .setColorForeground(255)
    .setColorBackground(Green)
    .setColorValue(Green)
    .setRange(0, 1000)
    .setNumberOfTickMarks(51)
    .setColorTickMark(Green)
    .setValue(10)
    ;
  Moncp5.getController("SliderAttack").getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-80);
  Moncp5.getController("SliderAttack").getValueLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(-30);
}

void draw() {
  background(0);
  text("Open: " + NomFichierAudio, 20, 30);
  // text(float(int((MonSampler.position())/100.0)) / 10 + " sec", 560, 50);
  // text(MonSampler.channelCount() + " channels   " + int(MonSampler.sampleRate()) + " Hz   "+ float(int((MonSampler.length())/100.0)) / 10 + " sec", 20, 50);
  text(MonSampler.channelCount() + " channels   " + int(MonSampler.sampleRate()) + " Hz   ", 20, 50);
  text("P: Play", 100, 80);
  text("S: Stop", 100, 100);
  text("L: Loop " + MonSampler.looping, 100, 120);
  text("R: Loop Random", 100, 140);
  text("esc: Quit", 100, 160);
  text("library minim: Sampler", 20, 350);

  // audio.getLastValues().length
  // MonSampler.attack.setLastValue(At/1000.0);
}

void keyPressed() {
  if (key == 'p' || key == 'P') MonSampler.trigger();
  if (key == 's' || key == 'S') MonSampler.stop();
  if (key == 'l' || key == 'L') MonSampler.looping = !MonSampler.looping;
  if (key == 'r' || key == 'R') {
    int hasard1 = int(random(NbrEchantillonFichier));
    int hasard2 = int(random(hasard1, NbrEchantillonFichier));
    MonSampler.begin.setLastValue(hasard1);
    MonSampler.end.setLastValue(hasard2); // samples
  }
}

void SliderBalance(int Bal) {
  Sortie.setBalance(Bal/100.0);
}

void SliderPan(int Pano) {
  Sortie.setPan(Pano/100.0);
}

void SliderAmplitude(int A) { // A = 0 .. 200
  MonSampler.amplitude.setLastValue(A/100.0);
}

void SliderAttack(int At) { // At = 0 .. 1000
  MonSampler.attack.setLastValue(At/1000.0);
}
