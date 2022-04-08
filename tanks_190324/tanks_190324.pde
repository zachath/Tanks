//Michael Foussianis
//Zacharias Thorell
/*
* JUST NU: 

*/

// för ljud
import ddf.minim.*;



// Ljud
Minim minim;
SoundManager soundManager;

boolean debugOn = false;
boolean pause = false;
boolean gameOver = false;

Grid grid;
int cols = 15;
int rows = 15;
int grid_size = 50;

// Boolean variables connected to keys
boolean left, right, up, down;
boolean fire;
boolean alt_key; // Turning turret, alt+LEFT/RIGHT

boolean mouse_pressed;
boolean userControl;
int tankInFocus;

color team0Color = color(204, 50, 50);
color team1Color = color(0, 150, 200);

CannonBall[] allShots = new CannonBall[6];

Tree[] allTrees = new Tree[3];

Tank[] allTanks = new Tank[6];

Team[] teams = new Team[2];

int tank_size = 50;
// Team0
PVector team0_tank0_startpos;
PVector team0_tank1_startpos;
PVector team0_tank2_startpos;

// Team1
PVector team1_tank0_startpos;
PVector team1_tank1_startpos;
PVector team1_tank2_startpos;

// timer
int savedTime;
int wait = 3000; //wait 3 sec (reload)
boolean tick;

Timer timer;
int startTime = 15; //minutes 
int remainingTime;

void setup(){
  size(800, 800);
  
  soundManager = new SoundManager(this);
  soundManager.addSound("tank_firing");
  soundManager.addSound("tank_idle");
  soundManager.addSound("blast");
  
  grid = new Grid(cols, rows, grid_size);
  
  //grid = new Node[cols][rows];
  //for (int i = 0; i < cols; i++) {
  //  for (int j = 0; j < rows; j++) {
  //    // Initialize each object
  //    grid[i][j] = new Node(i,j,i*grid_size, j*grid_size);
  //  }
  //}
  
  
  // Skapa alla träd
  allTrees[0] = new Tree(230, 600);
  allTrees[1] = new Tree(280,230);//280,230(300,300)
  allTrees[2] = new Tree(530, 520);//530, 520(500,500);

  // Skapa alla skott
  for (int i = 0; i < allShots.length; i++) {
    allShots[i] = new CannonBall();
  }
  
  // Team0
  team0_tank0_startpos = new PVector(50, 50);
  team0_tank1_startpos = new PVector(50, 150);
  team0_tank2_startpos = new PVector(50, 250);

  // Team1
  team1_tank0_startpos = new PVector(width-50, height-250);
  team1_tank1_startpos = new PVector(width-50, height-150);
  team1_tank2_startpos = new PVector(width-50, height-50);
  
 
  // nytt Team: id, color, tank0pos, id, shot
  teams[0] = new Team1(0, tank_size, team0Color, 
                      team0_tank0_startpos, 0, allShots[0],
                      team0_tank1_startpos, 1, allShots[1],
                      team0_tank2_startpos, 2, allShots[2]);
  
  allTanks[0] = teams[0].tanks[0];
  allTanks[1] = teams[0].tanks[1];
  allTanks[2] = teams[0].tanks[2];
  
  teams[1] = new Team2(1, tank_size, team1Color, 
                      team1_tank0_startpos, 3, allShots[3],
                      team1_tank1_startpos, 4, allShots[4],
                      team1_tank2_startpos, 5, allShots[5]);
  
  allTanks[3] = teams[1].tanks[0];
  allTanks[4] = teams[1].tanks[1];
  allTanks[5] = teams[1].tanks[2];
  
  for (Tank tank : allTanks) {
    grid.addContent(tank);
  }
  
  loadShots();
  userControl = false;
  tankInFocus = 0;
  
  savedTime = millis(); //store the current time.
  
  remainingTime = startTime;
  timer = new Timer();
  timer.setDirection("down");
  timer.setTime(startTime);
}


void draw() {
  background(200);
  checkForInput(); // Kontrollera inmatning.
  
  if (!gameOver && !pause) {
    // timer används inte i dagsläget.
    timer.tick(); // Alt.1
    float deltaTime = timer.getDeltaSec();
    remainingTime = int(timer.getTotalTime()); 
    if (remainingTime <= 0) {
      remainingTime = 0;
      timer.pause();
      gameOver = true;  
    }
    
    int passedTime = millis() - savedTime; // Alt.2
    
    //check the difference between now and the previously stored time is greater than the wait interval
    if (passedTime > wait){    
      //savedTime = millis();//also update the stored time   
    }
    
    // UPDATE LOGIC
    updateTanksLogic();
    updateTeamsLogic();
    
    // UPDATE TANKS
    updateTanks();
    updateShots();
   
    // CHECK FOR COLLISIONS
    checkForCollisionsShots(); 
    checkForCollisionsTanks();  
    
  }
  
  // UPDATE DISPLAY  
   teams[0].displayHomeBase();
   teams[1].displayHomeBase();
   displayTrees();
   updateTanksDisplay();  
   updateShotsDisplay();
   
   
  
  showGUI();
  
}

// Används inte
float getTime() {
  return 0; //Dummy temp
}
