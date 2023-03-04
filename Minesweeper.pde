import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean gameover = false;
public void setup ()
{
    size(400, 430);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r<NUM_ROWS; r++){
      for(int c = 0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
}
public void setMines()
{
    //your code
    while(mines.size()<buttons.length*4){
      int ranr = (int)(Math.random()*NUM_ROWS);
      int ranc = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[ranr][ranc]))
        mines.add(buttons[ranr][ranc]);
        
    }
}

public void draw ()
{
    background( 0 );
    fill(250);
    textSize(15);
    int count = 0;
    for(int r = 0; r<NUM_ROWS; r++){
      for(int c = 0; c<NUM_COLS; c++){
        if(buttons[r][c].isFlagged()==true)
          count++;
      }
    }
    text("flags left: "+(mines.size()-count), width/2, height-20);
    if(isWon() == true){
        displayWinningMessage();
    }  
}
public boolean isWon()
{
    //your code here
    int x = 0;
    int y = 0;
    for(int r = 0; r<NUM_ROWS; r++){
      for(int c = 0; c<NUM_COLS; c++){
        if(buttons[r][c].clicked==true)
          y++;
          if(mines.contains(buttons[r][c])&&buttons[r][c].isFlagged())
            x++;
      }
    }
    if(x==mines.size()&&y==buttons.length*buttons.length)
      return true;
    return false;
    
}
public void displayLosingMessage()
{
    //your code here
    //reveals all bombs
    for(int r = 0; r<NUM_ROWS; r++){
      for(int c = 0; c<NUM_COLS; c++){
        if(mines.contains(buttons[r][c])){
          if(mines.contains(buttons[r][c])&&buttons[r][c].flagged == true)
            buttons[r][c].flagged = false;
           buttons[r][c].clicked = true;
           fill(255,0,0);
        }
      }
    }
    //says you lose
    gameover = true;
    String str = "GAME OVER!";
    for(int i = 0; i<NUM_COLS; i++){
      buttons[NUM_ROWS/2][i+5].setLabel(str.substring(i, i+1));
    }
    
}
public void displayWinningMessage()
{
    //your code here
    fill(0);
    rect(width/2-60, height-30, 150, 50);
    fill(250);
    text("YOU WIN! CONGRATS", width/2, height-20);
    
}
public boolean isValid(int r, int c)
{
    //your code here
  if(r>=NUM_ROWS||r<0)
    return false;
  if(c>=NUM_COLS||c<0)
    return false;
  return true;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int r = row-1; r<=row+1; r++){
      for(int c = col-1; c<=col+1; c++){
        if(r==row&&c==col)
           numMines=numMines;
        else if(isValid(r,c)==true && mines.contains(buttons[r][c]))
          numMines++;
      }
}
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(gameover == true || (clicked && !flagged))
        return;
     
      clicked = true;
        //your code here
        if(mouseButton == RIGHT){
          if(flagged == false){
            flagged = true;
          }else{
            flagged = false;
            clicked = false;
          }
        }
        
        else if(flagged)
          return;
        else if(clicked && mines.contains(this)){
          displayLosingMessage();

        }
        else if(countMines(myRow, myCol)>0)
          setLabel(countMines(myRow, myCol));
        else{
          for(int r = myRow-1; r<=myRow+1; r++){
            for(int c = myCol-1; c<=myCol+1; c++){
              if(isValid(r, c) && !buttons[r][c].isFlagged() && buttons[r][c].clicked==false)
                buttons[r][c].mousePressed();
            }
          }
        }
    
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(12);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
