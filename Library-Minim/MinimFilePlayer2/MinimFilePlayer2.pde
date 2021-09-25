// MinimFilePlayer2.pde
// 25 9 2021
// Gerard Paresys
// https://github.com/gerardparesys/Processing-examples
//
// Play .mp3 audio files placed on the websites:
// https://paresys.pagesperso-orange.fr/Soundscape/
// http://gerard.paresys.free.fr/Soundscape/
// 44100Hz 16bits Stereo 192kbps 
// The same files are present on these 2 websites.
// and on:
// https://soundcloud.com/gerard-paresys/sets/paresys-field-recording
//
// Crash with mono audio files: Train1.mp3, Train2.mp3, Bird4.mp3
//       -> MonMinim.getLineOut(Minim.STEREO) -> Minim.MONO
//
// Processing 3.5.4 + MacOS
//    OK Site orange.fr 
//    OK Site free.fr
//    OK with the files in a data folder
// Processing 3.5.3 + Raspberry Pi OS (Raspbian 10 buster)
//    Pb Site orange.fr: Play stops after 23sec except files <120sec (Aqua1 Calme1 Calme2 Cloche1)
//    Pb Site orange.fr & free.fr & files in a data folder: Cannot restart playback of a 2nd file
// Processing 3.5.3 + Windows
//    OK Site free.fr 
//    Pb Site orange.fr: Play stops after 20sec except files <120sec (Aqua1 Calme1 Calme2 Cloche1)!
// Pb Site orange.fr & free.fr: MonFilePlayer.length()   is false;
// Pb Site orange.fr & free.fr: MonFilePlayer.position() is false;
//
// with library minim
// Exige une connexion internet
// Please note that some websites prohibit many fast access to files...
//
// http://code.compartmental.net/minim/fileplayer_class_fileplayer.html
// http://code.compartmental.net/minim/audiooutput_class_audiooutput.html
// http://code.compartmental.net/minim/audiometadata_class_audiometadata.html
// 

import ddf.minim.*;
import ddf.minim.spi.*; // for AudioRecordingStream
import ddf.minim.ugens.*;

String WebSite = "http://gerard.paresys.free.fr/Soundscape/";
// String WebSite = "https://paresys.pagesperso-orange.fr/Soundscape/";
// String WebSite = ""; // files in the data folder
String[] NomFichierAudio = { 
  "Abeille.mp3", 
  "Abeille2.mp3", 
  "Aqua1.mp3", 
  "Aqua2.mp3", 
  "Aqua3.mp3", 
  "Aqua4.mp3", 
  "Bat1.mp3", 
  "Bernache.mp3", 
  "Bird1.mp3", 
  "Bird2.mp3", 
  "Bird3.mp3", 
  //  "Bird4.mp3",   //  mono file
  "Bird5.mp3", 
  "Bird6.mp3", 
  "Calme1.mp3", 
  "Calme2.mp3", 
  "Calme3.mp3", 
  "Calme4.mp3", 
  "Calme5.mp3", 
  "Canal1.mp3", 
  "Canal2.mp3", 
  "Cave1.mp3", 
  "Cloche1.mp3", 
  "Cloche2.mp3", 
  "Cloche3.mp3", 
  "Cloche4.mp3", 
  "Commerce1.mp3", 
  "Debacle1.mp3", 
  "Equitation.mp3", 
  "Equitation2.mp3", 
  "Eruption.mp3", 
  "Insecte1.mp3", 
  "Nuit1.mp3", 
  "Pluie1.mp3", 
  "Pluie2.mp3", 
  "Pluie3.mp3", 
  "Pluie4.mp3", 
  "Pluie5.mp3", 
  "Pluie6.mp3", 
  "Pluie7.mp3", 
  "Port1.mp3", 
  "Port2.mp3", 
  "Square.mp3", 
  //  "Train1.mp3",   //  mono file
  //  "Train2.mp3",   //  mono file
  "Train3.mp3", 
  "Travail1.mp3", 
  "Vent1.mp3", 
  "Vent2.mp3", 
  "Vent3.mp3", 
  "Vent4.mp3", 
  "Vent5.mp3", 
  "Vent6.mp3", 
  "Ville1.mp3"
};
int IndiceNomFichierAudio = 0;
int xx;
int yy = 30;
color Green = color(0, 255, 0);
int Pause = 0;

Minim MonMinim;
FilePlayer MonFilePlayer;
AudioOutput Sortie;
AudioMetaData meta;
boolean MonFilePlayerExist = false;

void setup() {
  size(640, 460);
  xx = width / 4 - 1;
  textSize(16);
  stroke(Green);
  frameRate(10);
  MonMinim = new Minim(this);
  // MonMinim.debugOn();
  Sortie = MonMinim.getLineOut(Minim.STEREO); // Minim.MONO  Minim.STEREO
  ChargeFichier(NomFichierAudio[IndiceNomFichierAudio]);
}

void draw() {
  background(0);
  fill(Green);
  text("esc: Quit   SpaceBar: Play/Pause   " + "Position=" + float(int((MonFilePlayer.position())/100.0)) / 10 + "sec", 10, height - 22);
  // text("Frame=" + frameCount, 500, height - 22);
  text("Time=" + float(int((millis()-Pause)/100.0)) / 10 + "sec", 500, height - 22);
  text(WebSite + NomFichierAudio[IndiceNomFichierAudio] + "   " + float(int((MonFilePlayer.length())/100.0)) / 10 + "sec", 10, height - 5);
  int x = 0;
  int y = 0;
  int fff = 0;
  for (x = 0; x < width - 5; x = x + width / 4 - 1) { 
    for (y = 0; y < height - 2 * yy; y = y + yy) { 
      if ((IndiceNomFichierAudio == fff) && (MonFilePlayer.isPlaying())) {
        fill(Green);
        rect(x, y, xx, yy, 7);
        fill(0);
        if (fff < NomFichierAudio.length) text(NomFichierAudio[fff], x + 10, y + 23);
      } else {
        fill(0);
        rect(x, y, xx, yy, 7);
        fill(Green);
        if (fff < NomFichierAudio.length) text(NomFichierAudio[fff], x + 10, y + 21);
      }
      fff = fff + 1;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if (MonFilePlayer.isPlaying()) MonFilePlayer.pause(); 
    else MonFilePlayer.play();
  }
}

void mousePressed() {
  int Indice = mouseY / yy + 14 * (mouseX / (width / 4 - 1));
  if (Indice < NomFichierAudio.length) {
    IndiceNomFichierAudio = Indice;
    if (MonFilePlayer.isPlaying()) {
      MonFilePlayer.pause();
      ChargeFichier(NomFichierAudio[IndiceNomFichierAudio]);
    } else {
      // MonFilePlayer.rewind();
      ChargeFichier(NomFichierAudio[IndiceNomFichierAudio]);
      MonFilePlayer.play();
      Pause = millis();
    }
  } else MonFilePlayer.pause();
}

void ChargeFichier(String Nom) {
  if (MonFilePlayerExist) MonFilePlayer.close();
  String NomFichier = WebSite + Nom;
  AudioRecordingStream ARS = MonMinim.loadFileStream(NomFichier);
  MonFilePlayer = new FilePlayer(ARS);
  MonFilePlayerExist = true;
  MonFilePlayer.patch(Sortie); // patch the file player to the output
  println("Load File: " + NomFichier);
  println(ARS.getFormat().getChannels() + " channels   " + int(ARS.getFormat().getSampleRate()) + " Hz   " + ARS.getFormat().getSampleSizeInBits() + " bits   ");
  // println(ARS.getMillisecondLength());
  // println(ARS.getSampleFrameLength());
  meta = MonFilePlayer.getMetaData();
  println("MetaData:");
  println("    File Name: " + meta.fileName());
  println("    Length (in milliseconds): " + meta.length());
  println("    Title: " + meta.title());
  println("    Author: " + meta.author());
  println("    Album: " + meta.album());
  println("    Date: " + meta.date());
  println("    Comment: " + meta.comment());
  println("    Lyrics: " + meta.lyrics());
  println("    Track: " + meta.track());
  println("    Genre: " + meta.genre());
  println("    Copyright: " + meta.copyright());
  println("    Disc: " + meta.disc());
  println("    Composer: " + meta.composer());
  println("    Orchestra: " + meta.orchestra());
  println("    Publisher: " + meta.publisher());
  println("    Encoded: " + meta.encoded());
}
