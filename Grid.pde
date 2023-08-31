class Grid {
  static final int ALIVE = 1;
  static final int DEAD = 0;
  static final int CENTER = -56453;

  int MIN_WIDTH;
  int MIN_HEIGHT;

  int squareSize = 40;
  int generation = 0;
  int lines;
  int columns;

  ArrayList<ArrayList<Integer>> playground;
  
  long lastFrameUpdated = 0;

  Grid() {
    MIN_WIDTH = ceil(width/float(squareSize));
    MIN_HEIGHT = ceil(height/float(squareSize));

    this.playground = new ArrayList<ArrayList<Integer>>();

    for (int line = 0; line < MIN_HEIGHT; line++) {
      this.playground.add(new ArrayList<Integer>());
      for (int column = 0; column < MIN_WIDTH; column++) {
        this.playground.get(line).add(DEAD);
      }
    }

    this.lines = MIN_HEIGHT;
    this.columns = MIN_WIDTH;
  }

  void display() {
    stroke(200);
    for (int line = 0; line < this.lines; line++) {
      for (int column = 0; column < this.columns; column++) {
        Integer cell = this.playground.get(line).get(column);
        fill(255 * (1-cell));
        square(column*squareSize, line*squareSize, squareSize);
      }
    }
  }
  
  void update(long frame){
    float minFrameDistanceToUpdate = frameRate/speed;
    if(frame - this.lastFrameUpdated > minFrameDistanceToUpdate){
      this.play();
      this.lastFrameUpdated = frame;
    }
  }
  
  void play(){
    ArrayList<ArrayList<Integer>> newGrid = new ArrayList();
    for (int line = 0; line < this.lines; line++) {
      newGrid.add(new ArrayList());
      for (int column = 0; column < this.columns; column++) {
        int n = countNeighbours(line, column);
        int cell = this.playground.get(line).get(column);
        
        boolean added = false;
        
        if(cell == ALIVE){
          if(n <= 1) {
            newGrid.get(line).add(DEAD);
            added = true;
          } else if(n >= 4){
            newGrid.get(line).add(DEAD);
            added = true;
          }
        } else if (cell == DEAD){
          if(n == 3) {
            newGrid.get(line).add(ALIVE);
            added = true;
          } 
        }
        
        if(!added){
          newGrid.get(line).add(cell);
        }
      }
    }
    
    this.playground = newGrid;
    this.generation++;
  }

  int countNeighbours(int line, int column) {
    if (line > 0 && line < this.lines-1) {
      if (column > 0 && column < this.columns-1) {
        
        return this.playground.get(line-1).get(column-1)+this.playground.get(line-1).get(column)+this.playground.get(line-1).get(column+1)+
               this.playground.get(line).get(column-1)+                                         +this.playground.get(line).get(column+1)+
               this.playground.get(line+1).get(column-1)+this.playground.get(line+1).get(column)+this.playground.get(line+1).get(column+1);
               
      } else if (column==0) {
        return this.playground.get(line-1).get(column)+this.playground.get(line-1).get(column+1)+
                                                      +this.playground.get(line).get(column+1)+
              +this.playground.get(line+1).get(column)+this.playground.get(line+1).get(column+1);
              
      } else if (column == this.columns-1) {
        return this.playground.get(line-1).get(column-1)+this.playground.get(line-1).get(column)+
               this.playground.get(line).get(column-1)+
               this.playground.get(line+1).get(column-1)+this.playground.get(line+1).get(column);
               
      } else return 0;
      
      
    } else if (line == 0) {
      if (column > 0 && column < this.columns-1) {
        return 
          this.playground.get(line).get(column-1)                                          +this.playground.get(line).get(column+1)+
          this.playground.get(line+1).get(column-1)+this.playground.get(line+1).get(column)+this.playground.get(line+1).get(column+1);
          
      } else if (column==0) {
        return
                                                   this.playground.get(line).get(column+1)+
          +this.playground.get(line+1).get(column)+this.playground.get(line+1).get(column+1);
          
      } else if (column == this.columns-1) {
        return
          this.playground.get(line).get(column-1)+
          this.playground.get(line+1).get(column-1)+this.playground.get(line+1).get(column);
          
      } else return 0;
      
      
      
    } else if (line == this.lines-1) {
      if (column > 0 && column < this.columns-1) {
        return this.playground.get(line-1).get(column-1)+this.playground.get(line-1).get(column)+this.playground.get(line-1).get(column+1)+
               this.playground.get(line).get(column-1)+                                         +this.playground.get(line).get(column+1);
               
      } else if (column==0) {
        return this.playground.get(line-1).get(column)+this.playground.get(line-1).get(column+1)+
                                                      +this.playground.get(line).get(column+1);
                                                      
      } else if (column == this.columns-1) {
        return this.playground.get(line-1).get(column-1)+this.playground.get(line-1).get(column)+
               this.playground.get(line).get(column-1);
               
      } else return 0;
      
    } else return 0;
  }
  
  
  void toggle(int line, int column){
    if(line >= 0 && line < this.lines){
      if(column >= 0 && line < this.columns){
        int cell = this.playground.get(line).get(column);
        this.playground.get(line).set(column, 1-cell);
      }
    } 
  }
  
  void clear(){
    this.generation = 0;
    for (int line = 0; line < this.lines; line++) {
      for (int column = 0; column < this.columns; column++) {
        this.playground.get(line).set(column, DEAD);
      }
    }
  }
  
  void add(int[][] shape, int x, int y){
    int shapeLines = shape.length;
    int shapeColumns = shape[0].length;
    
    int startingColumn = x;
    int startingLine = y;
    if(x == CENTER){
      startingColumn = max(0,(this.columns-shapeColumns)/2);
    }
    if(y == CENTER){
      startingLine = max(0,(this.lines-shapeLines)/2);
    }
    
    if(shapeLines+startingLine >= this.lines || shapeColumns+startingColumn >= this.columns) return;
    
    
    for(int line = 0; line < shapeLines; line++){
      for(int column = 0; column < shapeColumns; column++){
        int cell = shape[line][column];
        this.playground.get(line+startingLine).set(column+startingColumn, cell);
      }
    }
  }
  
  void setSquareSize(int size){
    this.squareSize = size;
    MIN_WIDTH = ceil(width/float(squareSize));
    MIN_HEIGHT = ceil(height/float(squareSize));

    for (int line = 0; line < this.lines; line++) {
      for (int column = 0; column < MIN_WIDTH; column++) {
        this.playground.get(line).add(DEAD);
      }
    }
    
    for (int line = this.lines; line < MIN_HEIGHT; line++) {
      this.playground.add(new ArrayList<Integer>());
      for (int column = 0; column < MIN_WIDTH; column++) {
        this.playground.get(line).add(DEAD);
      }
    }

    this.lines = MIN_HEIGHT;
    this.columns = MIN_WIDTH;
  
  }

}
