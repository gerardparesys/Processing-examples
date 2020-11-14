// TextGrid3.pde
// 25 7 2020
// Gerard Paresys
//
// OK Processing 3
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

// String NomFichierAudio = "ONSBJ_alexei.wav";
String NomFichierAudio = "16rondatipica_X.mp3";

int NbrTierMax = 5;
int TailleMaxTier = 5000;

Table Tableau;

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

  Tableau = loadTable(NomFichierTextGrid, "tsv");
  println(Tableau.getColumnCount() + " columns in " + NomFichierTextGrid);
  println(Tableau.getRowCount() + " rows in " + NomFichierTextGrid);
  println();

  int Rrr = 0;
  String[] liiist;
  for (TableRow row : Tableau.rows()) { 
    String sss0 = row.getString(0);
    sss0 = trim(sss0);
    if (match(sss0, "name = ") != null) {
      Rrr = 0;
      NumeroTier = NumeroTier + 1;
      liiist = split(sss0, ' ');
      liiist[2] = liiist[2].substring(1, liiist[2].length()-1);
      TierNom[NumeroTier] = liiist[2];
      println("TierNom[" + NumeroTier + "] = " + TierNom[NumeroTier]);
    }
    if (match(sss0, "xmin = ") != null) {
      if (NumeroTier > -1) {
        liiist = split(sss0, ' ');
        Tierxmin[NumeroTier][Rrr] = float(liiist[2]);
        println("Tierxmin[" + NumeroTier + "][" + Rrr + "] = " + Tierxmin[NumeroTier][Rrr]);
      }
    }
    if (match(sss0, "xmax = ") != null) {
      if (NumeroTier > -1) {
        liiist = split(sss0, ' ');
        Tierxmax[NumeroTier][Rrr] = float(liiist[2]);
        println("Tierxmax[" + NumeroTier + "][" + Rrr + "] = " + Tierxmax[NumeroTier][Rrr]);
      }
    }
    if (match(sss0, "text = ") != null) {
      if (NumeroTier > -1) {
        sss0 = sss0.substring(8, sss0.length()-1);    
        TierStr[NumeroTier][Rrr] = sss0;
        println("TierStr[" + NumeroTier + "][" + Rrr + "] = " + TierStr[NumeroTier][Rrr]);
        Rrr = Rrr + 1;
      }
    }
  }
  println();
  println(NumeroTier + 1 + " Tiers in " + NomFichierTextGrid + ":");
  for (int i = 0; i < NumeroTier + 1; i++) print(TierNom[i] + "  ");
  println();
  Initialisation();
  minim = new Minim(this);  // create our Minim object for loading audio
  MonPlayer = minim.loadFile(NomFichierAudio, 1024);
}

void draw() {
  background(0);
  textSize(16);
  fill(0, 255, 0);
  text("Ouverture: " + NomFichierTextGrid, 100, 40);
  text("P: Play     " + NomFichierAudio, 100, 80);
  text("S: Stop", 100, 100);
  if (NumeroTier < 1) text("Problem: No Tier in the file: " + NomFichierTextGrid, 10, 140 + 20);
  for (int i = 0; i < NumeroTier + 1; i = i+1) { 
    text("Tier" + (i + 1) + "  " + TierNom[i], 10, 140 + 20 * i);
    text(Texte[i], 190, 140 + 20 * i);
    if (MonPlayer.position() > Tierxmin[i][Index[i]] * 1000) { // MonPlayer.position() en ms
      if (TierStr[i][Index[i]] != null) {
        Texte[i] = TierStr[i][Index[i]];
        Index[i] = Index[i] + 1;
      }
    }
  }
  text(float(int((MonPlayer.position())/100.0)) / 10 + " sec", 100, 330);
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    Initialisation();
    MonPlayer = minim.loadFile(NomFichierAudio, 1024);
    MonPlayer.play();
  }
  if (key == 's' || key == 'S') MonPlayer.pause();
}

void Initialisation() {
  for (int i = 0; i < NumeroTier + 1; i = i+1) { 
    Index[i] = 0;
    Texte[i] = " ";
  }
}
