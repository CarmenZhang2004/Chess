import processing.net.*;

Server myServer;

color lightbrown = #FFFFC3;
color darkbrown = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
boolean itsMyTurn = true;
int row1, col1, row2, col2, M;

char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

char back;
char lastpiece;

void setup() {
  size(800, 800);
  
  myServer = new Server(this, 1234);
  
  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  drawBoard();
  highlight();
  drawPieces();
  receiveMove();
  //pawn();
}

void receiveMove(){
  Client myClient = myServer.available();
  if(M == 0){
  if (myClient != null){
    String incoming = myClient.readString();
    int r1 = int (incoming.substring(0, 1));
    int c1 = int (incoming.substring(2, 3));
    int r2 = int (incoming.substring(4, 5));
    int c2 = int (incoming.substring(6, 7));
    grid[r2][c2] = grid[r1][c1];
    grid[r1][c1] = ' ';
    itsMyTurn = true;
  }
  }
  
  if(M == 1){
    if (myClient != null){
      String incoming = myClient.readString();
      int a = int (incoming.substring(8, 9));
      int b = int (incoming.substring(10, 11));
      int c = int (incoming.substring(12, 13));
      int d = int (incoming.substring(14, 15));
      grid[a][b] = back;
      grid[c][d] = lastpiece;
      itsMyTurn = false;
    }
  }
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      stroke(0);
      strokeWeight(1);
      rect(c*100, r*100, 100, 100);
    }
  }
}

void highlight(){
  if (firstClick == false && itsMyTurn){
    noFill();
    stroke(0);
    strokeWeight(5);
    rect(col1*100, row1*100, 100, 100);
  } else if (firstClick == true){
    noFill();
    noStroke();
    rect(col1*100, row1*100, 100, 100);
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

//void pawn(){
  //int r = 0;
  //if ('p' == grid[r][c]){
    
 // }
//}

void mouseReleased() {
  if (firstClick) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    back = grid[row1][col1];
    firstClick = false;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    if (itsMyTurn && !(row2 == row1 && col2 == col1)) {
      lastpiece = grid[row2][col2];
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myServer.write (row1 + "," + col1 + "," + row2 + "," + col2);
      M = 0;
      firstClick = true;
      itsMyTurn = false;
    }
  }
}

void keyReleased(){
  if (key == 'z' || key == 'Z'){
    M = 1;
    grid[row1][col1] = back;
    grid[row2][col2] = lastpiece;
    itsMyTurn = true;
  }
}
