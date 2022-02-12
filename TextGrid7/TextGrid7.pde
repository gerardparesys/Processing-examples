// TextGrid7.pde
// 10 2 2022
// Gerard Paresys
//
// OK Processing 1.5.1
// OK Processing 2
// OK Processing 3
//
// with library minim
//
// http://code.compartmental.net/minim/audioplayer_class_audioplayer.html
//
// idem TextGrid4 sans utiliser la class Table pour etre compatible Processing 1.5
// idem TextGrid5 + Pause
// idem TextGrid6 + if(sss0.length() > 0)...
//
// Ouvre un fichier "xxx.TextGrid" encode UTF-8
// https://www.fon.hum.uva.nl/praat/manual/TextGrid_file_formats.html
// Affiche les tiers en synchronisation avec la lecture Audio
//
// En cas de probleme "O Tiers in xxx.TextGrid":
// Verifier l'encodage UTF-8 du fichier .TextGrid
// 

import ddf.minim.*;

// String NomFichierTextGrid = "ONSBJ_alexei-merge.TextGrid";
String NomFichierTextGrid = "16rondatipica_X.TextGrid";
// String NomFichierTextGrid = "maore.TextGrid";
// String NomFichierTextGrid = "kabyle.TextGrid";

// String NomFichierAudio = "ONSBJ_alexei.wav";
String NomFichierAudio = "16rondatipica_X.mp3";
// String NomFichierAudio = "maore.mp3";
// String NomFichierAudio = "kabyle.mp3";

int NbrTierMax = 5;
int TailleMaxTier = 5000;
boolean Affiche = false;
boolean Pause = true;

String[] Tableau;
String[]   TierNom  = new String[NbrTierMax];
float[][]  Tierxmin = new float[NbrTierMax][TailleMaxTier];
float[][]  Tierxmax = new float[NbrTierMax][TailleMaxTier];
String[][] TierStr  = new String[NbrTierMax][TailleMaxTier];
int[]      Index    = new int[NbrTierMax];
String[]   Texte    = new String[NbrTierMax];
int NumeroTier = -1;

AudioPlayer MonPlayer;
Minim minim;

void setup() {
  size(640, 360);
  noStroke();
  ChargeTextGrid();
  minim = new Minim(this);  // create our Minim object for loading audio
  Initialisation();
}

void draw() {
  background(0);
  textSize(16);
  fill(0, 255, 0);
  text("Ouverture: " + NomFichierTextGrid, 100, 40);
  text("P: Play     " + NomFichierAudio, 100, 80);
  text("Space bar: Pause", 33, 100);
  text("S: Stop", 100, 120);
  text("esc: Quit", 84, 140);
  if (NumeroTier < 1) text("Problem: No Tier in the file: " + NomFichierTextGrid, 10, 180 + 20);
  for (int i = 0; i < NumeroTier + 1; i = i+1) { 
    text("Tier" + i + "  " + TierNom[i], 10, 180 + 20 * i);
    text(Texte[i], 190, 180 + 20 * i);
    if (MonPlayer.position() > Tierxmin[i][Index[i]] * 1000) { // MonPlayer.position() en ms
      if (TierStr[i][Index[i]] != null) {
        Texte[i] = TierStr[i][Index[i]];
        Index[i] = Index[i] + 1;
        if (i == 2) println("Tier2  Index[2]=" + Index[i] + "  " + TierStr[i][Index[i]]);
        if (i == 4) println("Tier4  Index[4]=" + Index[i] + "  " + TierStr[i][Index[i]]);
      }
    }
  }
  text(float(int((MonPlayer.position())/100.0)) / 10 + " sec", 100, 330);
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    MonPlayer.pause();
    Initialisation();
    MonPlayer.play();
    Pause = false;
  }
  if (key == 's' || key == 'S') {
    MonPlayer.pause();
    Pause = true;
    MonPlayer.rewind();
  }
  if (key == ' ') {         // barre d'espace
    Pause = ! Pause;
    if (Pause) MonPlayer.pause();
    else MonPlayer.play();
  }
}

void Initialisation() {
  for (int i = 0; i < NbrTierMax; i = i+1) { 
    Index[i] = 0;
    Texte[i] = " ";
  }
  MonPlayer = minim.loadFile(NomFichierAudio, 1024);
}

void ChargeTextGrid() {
  NumeroTier = -1;
  String[] Tableau = loadStrings(NomFichierTextGrid);
  println(Tableau.length + " lines in " + NomFichierTextGrid);
  if (Affiche) println();
  if (Affiche) for (int i = 0; i < 10; i = i+1) println("Line " + i + "  " + Tableau [i]);
  if (Affiche) println();
  int Rrr = 0;
  String[] liiist;
  for (int i = 0; i < Tableau.length; i = i+1) { 
    String sss0 = Tableau[i];
    sss0 = trim(sss0);
    if (match(sss0, "name = ") != null) {
      Rrr = 0;
      NumeroTier = NumeroTier + 1;
      liiist = split(sss0, ' ');
      liiist[2] = liiist[2].substring(1, liiist[2].length()-1);
      TierNom[NumeroTier] = liiist[2];
      if (Affiche) println("TierNom[" + NumeroTier + "] = " + TierNom[NumeroTier]);
    }
    if (match(sss0, "xmin = ") != null) {
      if (NumeroTier > -1) {
        liiist = split(sss0, ' ');
        Tierxmin[NumeroTier][Rrr] = float(liiist[2]);
        if (Affiche) println("Tierxmin[" + NumeroTier + "][" + Rrr + "] = " + Tierxmin[NumeroTier][Rrr]);
      }
    }
    if (match(sss0, "xmax = ") != null) {
      if (NumeroTier > -1) {
        liiist = split(sss0, ' ');
        Tierxmax[NumeroTier][Rrr] = float(liiist[2]);
        if (Affiche) println("Tierxmax[" + NumeroTier + "][" + Rrr + "] = " + Tierxmax[NumeroTier][Rrr]);
      }
    }
    if (match(sss0, "text = ") != null) {
      if (NumeroTier > -1) {
        sss0 = sss0.substring(8);
        if (sss0.length() > 0) sss0 = sss0.substring(0, sss0.length()-1);
        TierStr[NumeroTier][Rrr] = sss0;
        if (Affiche) println("TierStr[" + NumeroTier + "][" + Rrr + "] = " + TierStr[NumeroTier][Rrr]);
        Rrr = Rrr + 1;
      }
    }
  }
  println();
  println(NumeroTier + 1 + " Tiers in " + NomFichierTextGrid + ":");
  for (int i = 0; i < NumeroTier + 1; i++) print(TierNom[i] + "  ");
  println();
}
