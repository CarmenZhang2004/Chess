import processing.net.*;

Server myServer;

color lightbrown = #FFFFC3;
color darkbrown = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
boolean itsMyTurn = true;
boolean promotion;
int row1, col1, row2, col2, M;
int shadowOffset = 5;

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

char lastpiece;
char pro = 'p';

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
  if (promotion == true) pawn();
}

void receiveMove() {
  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r1 = int (incoming.substring(0, 1));
    int c1 = int (incoming.substring(2, 3));
    int r2 = int (incoming.substring(4, 5));
    int c2 = int (incoming.substring(6, 7));
    int M = int (incoming.substring(8, 9));
    lastpiece = incoming.charAt(10);
    pro = incoming.charAt(12);
    println(incoming, M);
    if (M == 0) {
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      itsMyTurn = true;
    }

    if (M == 1) {
      grid[r1][c1] = grid[r2][c2];
      grid[r2][c2] = lastpiece;
      itsMyTurn = false;
    }

    if (M == 2) {
      println(r2, c2, pro);
      if (grid[r2][c2] == 'P' && r2 == 7) {      
        grid[r2][c2] = pro;
        itsMyTurn = true;
      }
    }
    
  }
}

void pawn() {
  stroke(0);
  strokeWeight(2);
  fill(247, 214, 152);
  rect(120, 250, 560, 300);
  textSize(70);
  textAlign(CENTER, CENTER);
  fill(lightbrown);
  text("Choose", width/2+shadowOffset, height/2.5+shadowOffset);
  fill(darkbrown);
  text("Choose", width/2, height/2.5);

  fill(255);

  rect(530, 400, 100, 100);
  image(wqueen, 530, 400, 100, 100);
  if (mouseX > 530 && mouseX < 630 && mouseY > 400 && mouseY < 500 && mousePressed) {
    grid[row2][col2] = 'q'; 
    promotion = false;
    pro = 'q';
    myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 2 + "," + lastpiece + "," + pro);
  }

  rect(170, 400, 100, 100);
  image (wrook, 170, 400, 100, 100);
  if (mouseX > 170 && mouseX < 270 && mouseY > 400 && mouseY < 500 && mousePressed) {
    grid[row2][col2] = 'r'; 
    promotion = false;
    pro = 'r';
    myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 2 + "," + lastpiece + "," + pro);
  }

  rect(410, 400, 100, 100);
  image(wknight, 410, 400, 100, 100);
  if (mouseX > 410 && mouseX < 510 && mouseY > 400 && mouseY < 500 && mousePressed) {
    grid[row2][col2] = 'n'; 
    promotion = false;
    pro = 'n';
    myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 2 + "," + lastpiece + "," + pro);
  }

  rect(290, 400, 100, 100);
  image(wbishop, 290, 400, 100, 100);
  if (mouseX > 290 && mouseX < 390 && mouseY > 400 && mouseY < 500 && mousePressed) {
    grid[row2][col2] = 'b'; 
    promotion = false;
    pro = 'b';
    myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 2 + "," + lastpiece + "," + pro);
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

void highlight() {
  if (firstClick == false && itsMyTurn) {
    noFill();
    stroke(0);
    strokeWeight(5);
    rect(col1*100, row1*100, 100, 100);
  } else if (firstClick == true) {
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

void mouseReleased() {
  if (firstClick) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    firstClick = false;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    lastpiece = grid[row2][col2];
    if (itsMyTurn && !(row2 == row1 && col2 == col1)) {
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myServer.write (row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + lastpiece + "," + "?");
      firstClick = true;
      itsMyTurn = false;
    }
  }

  if (grid[row2][col2] == 'p' && row2 == 0) {
    promotion = true;
  } else {
    promotion = false;
  }
}

void keyReleased() {
  if (key == 'z' || key == 'Z') {
    M = 1;
    grid[row1][col1] = grid[row2][col2];
    grid[row2][col2] = lastpiece;
    myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 1 + "," + lastpiece + "," + "?");
    promotion = false;
    itsMyTurn = true;
  }
  
  if (key == 'q' || key == 'Q'){
    
  }
}
