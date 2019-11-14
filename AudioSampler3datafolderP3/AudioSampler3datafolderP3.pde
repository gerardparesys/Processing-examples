// AudioSampler3datafolderP3.pde
// 20-1-2019
//
// OK Processing 3.3.7 MacOS 
//
// Utilise la library minim
//
// http://code.compartmental.net/minim/sampler_class_sampler.html
//
// BruitBlanc = White noise tres faible ajoute a la sortie 
// Tentative pour supprimer le bruit de fond d'une Rasbberry 
//

import ddf.minim.*;
import ddf.minim.ugens.*;

String NomFichier = "ONSBJ_anna.wav";
int NbrEchantillonFichier = 133084;
//String NomFichier = "Goch-Dwa(CreoleHaitien).wav";
//int NbrEchantillonFichier = 45439;
int maxVoices = 4; // the maximum number of voices for Sampler
boolean Attack1sec = false;
boolean Bruit = false;
boolean MuteSon = false;

Minim MonMinim;
AudioOutput Sortie;
Sampler Anna;
Noise BruitBlanc;

void setup() {
  size(640, 360);
  noStroke();

  MonMinim = new Minim(this);
  // MonMinim.debugOn(); // Uncomment...
  Sortie   = MonMinim.getLineOut();
  Sortie.unmute();
  Anna = new Sampler(NomFichier, maxVoices, MonMinim);
  Anna.patch(Sortie);
  BruitBlanc = new Noise( 0.01, Noise.Tint.WHITE);

  println("Anna.amplitude.getLastValue() = " + Anna.amplitude.getLastValue());
  println("Anna.attack.getLastValue() = " + Anna.attack.getLastValue());
  println("Anna.begin.getLastValues() = " + int(Anna.begin.getLastValues()));
  println("Anna.end.getLastValues() = " + int(Anna.end.getLastValues()));
  println("Anna.channelCount() = " + Anna.channelCount());
  println("Anna.printInputs():");
  Anna.printInputs(); // MonMinim.debugOn() pour voir
  println("Anna.sampleRate() = " + Anna.sampleRate());
  println("Anna.looping = " + Anna.looping);
  println("-----------------------");

  textSize(16);
  stroke(0, 255, 0);
}

void draw() {
  background(0);
  textSize(16);
  fill(0, 255, 0);
  if (MuteSon) text("M: Mute On", 100, 40);
  else text("M: Mute Off", 100, 40);
  text("Processing library minim: Sampler", 350, 40);
  text("P: Play " + NomFichier, 100, 80);
  text("S: Stop", 100, 100);
  text("L: Loop " + Anna.looping, 100, 140);
  text("A: Attack " + int(Attack1sec) + " sec", 100, 160);
  text("I: Amplitude 0dB", 100, 180);
  text("K: Amplitude -20dB", 100, 200);
  text("B: Begin randomly", 100, 240);
  text("E: End randomly", 100, 260);
  text("R: Right/Left balance randomly", 100, 280);
  text("Q: Begin = 0  End = max  Balance = center", 100, 300);
  if (Bruit) text("D: Noise -40dB On", 100, 340);
  else text("D: Noise -40dB Off", 100, 340);
  // rect(0, height - 20, width * Anna.percent() / 100.0, height);
}

void keyPressed() {
  if (key == 'm' || key == 'M') {
    MuteSon = !MuteSon;
    if (MuteSon) Sortie.mute();
    else Sortie.unmute();
  };
  if (key == 'p' || key == 'P') Anna.trigger();
  if (key == 's' || key == 'S') Anna.stop();
  if (key == 'l' || key == 'L') Anna.looping = !Anna.looping;
  if (key == 'a' || key == 'A') {
    Attack1sec = ! Attack1sec;
    Anna.attack.setLastValue(int(Attack1sec)); // secondes
  }
  if (key == 'i' || key == 'I') Anna.amplitude.setLastValue( 1 );
  if (key == 'k' || key == 'K') Anna.amplitude.setLastValue( 0.1 );
  if (key == 'b' || key == 'B') Anna.begin.setLastValue(random(NbrEchantillonFichier)); // samples
  if (key == 'e' || key == 'E') Anna.end.setLastValue(random(NbrEchantillonFichier)); // samples
  if (key == 'r' || key == 'R') Sortie.setBalance(random(-1, 1)); // -1 .. 1
  if (key == 'q' || key == 'Q') {
    Anna.begin.setLastValue(0); // samples
    Anna.end.setLastValue(NbrEchantillonFichier); // samples
    Sortie.setBalance(0); // -1 .. 1
  }
  //if (key == 'r' || key == 'R') Anna.pan(random(-1, 1));
  if (key == 'd' || key == 'D') {
    Bruit = !Bruit;
    if (Bruit) BruitBlanc.patch(Sortie);
    else BruitBlanc.unpatch(Sortie);
  };
}
