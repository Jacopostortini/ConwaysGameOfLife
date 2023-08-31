final float MIN_SPEED = 1/8.0;

float speed = 2;
boolean running = false;



Grid grid;

void setup() {
  size(1600, 800);
  frameRate(60);

  grid = new Grid();
}

void draw() {
  background(230);

  if (running) {
    grid.update(frameCount);
  }

  grid.display();
  
  if(dragging) {
    displayDrawingChessboard();
  }

  drawInfo();
}


void drawInfo() {

  textSize(20);
  fill(0);

  //Informations about the game
  textAlign(LEFT, TOP);
  if (speed >= 1) {
    text("Speed: "+int(speed)+" fps (+/- to change)", 5, 5);
  } else {
    text("Speed: "+speed+" fps (+/- to change)", 5, 5);
  }
  text("Generation: "+grid.generation, 5, 30);

  //Available commands

  text("BACKSPACE to clear", 5, 55);
  text("1-9 to set grid dimension", 5, 80);


  //Available shapes
  textAlign(RIGHT, TOP);
  text("Every shape is added at mouse position:", width-5, 5);
  text("o: glider gun shooting SW", width-5, 30);
  text("p: glider gun shooting SE", width-5, 55);
  text("q: glider heading NW", width-5, 80);
  text("w: glider heading NE", width-5, 105);
  text("a: glider heading SW", width-5, 130);
  text("s: glider heading SE", width-5, 155);
  text("Drag and drop to draw a chessboard", width-5, 180);


  //RUNNING / PAUSED
  textAlign(CENTER, TOP);
  fill(running ? #00ff00 : #ff0000);
  textSize(35);
  text(running ? "RUNNING" : "PAUSED", width/2, 5);
  textSize(15);
  text("(SPACE to toggle)", width/2, 45);
}


void keyPressed() {
  switch(key) {
  case '+':
    if (floor(speed)>=1) {
      speed++;
      speed = min(speed, frameRate);
      speed = floor(speed);
    } else {
      speed *= 2;
      speed = min(speed, 1);
    }
    break;
  case '-':
    if (floor(speed)>1) {
      speed--;
      speed = floor(speed);
    } else {
      speed /= 2;
      speed = max(speed, MIN_SPEED);
    }
    break;
  case ' ':
    running = !running;
    break;
  case BACKSPACE:
    running = false;
    grid.clear();
    break;
  case 'p':
    grid.add(Shapes.GLIDER_GUN_SE, int(mouseX/grid.squareSize), int(mouseY/grid.squareSize));
    break;
  case 'o':
    grid.add(Shapes.GLIDER_GUN_SW, int(mouseX/grid.squareSize), int(mouseY/grid.squareSize));
    break;
  case 'q':
    grid.add(Shapes.GLIDER_NW, int(mouseX/grid.squareSize), int(mouseY/grid.squareSize));
    break;
  case 'w':
    grid.add(Shapes.GLIDER_NE, int(mouseX/grid.squareSize), int(mouseY/grid.squareSize));
    break;
  case 'a':
    grid.add(Shapes.GLIDER_SW, int(mouseX/grid.squareSize), int(mouseY/grid.squareSize));
    break;
  case 's':
    grid.add(Shapes.GLIDER_SE, int(mouseX/grid.squareSize), int(mouseY/grid.squareSize));
    break;
  }

  if (keyCode >= 49 && keyCode <= 57) { //from 1 to 9
    grid.setSquareSize((key-48)*10);
  }
}

void mouseClicked() {
  int column = floor(mouseX/grid.squareSize);
  int line = floor(mouseY/grid.squareSize);

  grid.toggle(line, column);
}

boolean dragging = false;
long startingFrame = 0;
int startingLine = -1;
int startingColumn = -1;

void mousePressed(){
  if(!dragging){
    dragging = true;
    startingFrame = frameCount;
    startingLine = min(grid.lines, max(0, floor(mouseY/grid.squareSize)));
    startingColumn = min(grid.columns, max(0, floor(mouseX/grid.squareSize)));
  }
}

void mouseReleased(){
  if(dragging && frameCount-startingFrame>10){
    int endingLine = min(grid.lines, max(0, floor(mouseY/grid.squareSize)));
    int endingColumn = min(grid.columns, max(0, floor(mouseX/grid.squareSize)));
    
    int[][] shape = new int[abs(endingLine-startingLine)][abs(endingColumn-startingColumn)];
    for(int i = 0; i < shape.length; i++){
      for(int j = 0; j < shape[0].length; j++){
        if((i+j)%2 == 0){
          shape[i][j] = Grid.ALIVE;
        } else {
          shape[i][j] = Grid.DEAD;
        }
      }
    }
    
    grid.add(shape, min(startingColumn, endingColumn), min(startingLine, endingLine));
  }
  
  dragging = false;
}

void displayDrawingChessboard(){
  fill(200, 200, 200, 200);
  float ssLine = startingLine*grid.squareSize;
  float ssColumn = startingColumn*grid.squareSize;
  float esLine = floor(mouseY/grid.squareSize)*grid.squareSize;
  float esColumn = floor(mouseX/grid.squareSize)*grid.squareSize;
  
  float x = min(ssColumn, esColumn);
  float y = min(ssLine, esLine);
  float w = abs(ssColumn-esColumn);
  float h = abs(ssLine-esLine);
  rect(x, y, w, h);
}
