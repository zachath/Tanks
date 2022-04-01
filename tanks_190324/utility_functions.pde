
// call to Team updateLogic()
void updateTeamsLogic() {
  teams[0].updateLogic();
  teams[1].updateLogic();
}

// call to Tank updateLogic()
void updateTanksLogic() {
  
  for (Tank tank : allTanks) {
    if (tank.isReady) {
      tank.updateLogic();
    }
  }
  
  //for (int i = 0; i < tanks.length; i++) {
  //  this.tanks[i].updateLogic();
  //}
}

// call to Tank update()
void updateTanks() {
  
  for (Tank tank : allTanks) {
    //if (tank.health > 0)
    tank.update();
  }
  
  //for (int i = 0; i < tanks.length; i++) {
  //  this.tanks[i].updateLogic();
  //}
}

void updateShots() {
  for (int i = 0; i < allShots.length; i++) {
    if ((allShots[i].passedTime > wait) && (!allTanks[i].hasShot)) {
      allShots[i].resetTimer();
      allTanks[i].loadShot();
    }
    allShots[i].update();
  }
}

void checkForCollisionsShots() {
  for (int i = 0; i < allShots.length; i++) {
    if (allShots[i].isInMotion) {
      for (int j = 0; j<allTrees.length; j++) {
        allShots[i].checkCollision(allTrees[j]);
      }
     
      for (int j = 0; j < allTanks.length; j++) {
        if (j != allTanks[i].getId()) {
          allShots[i].checkCollision(allTanks[j]);
        }
      }
    }
  }
}

void checkForCollisionsTanks() {
  // Check for collisions with Canvas Boundaries
  for (int i = 0; i < allTanks.length; i++) {
    allTanks[i].checkEnvironment();
    
    // Check for collisions with "no Smart Objects", Obstacles (trees, etc.)
    for (int j = 0; j < allTrees.length; j++) {
      allTanks[i].checkCollision(allTrees[j]);
    }
    
    // Check for collisions with "Smart Objects", other Tanks.
    for (int j = 0; j < allTanks.length; j++) {
      //if ((allTanks[i].getId() != j) && (allTanks[i].health > 0)) {
      if (allTanks[i].getId() != j) {
        allTanks[i].checkCollision(allTanks[j]);
      }
    }
  }
}

void loadShots() {
  for (int i = 0; i < allTanks.length; i++) {
    allTanks[i].loadShot();
  }
}

//void shoot(Tank id, PVector pvec) {
void shoot(int id) {
  println("App.shoot()");
 // println(id +": "+ pvec);
  //allShots.get(id).setStartPosition(pvec);
  
  //myAudio.blast();
  
  allShots[id].isInMotion = true;
  allShots[id].startTimer();
}

void setTargetPosition(PVector pvec) {
  PVector nodevec = grid.getNearestNodePosition(pvec);
  //allTanks[tankInFocus].moveTo(pvec);
  allTanks[tankInFocus].moveTo(nodevec);
}

//******************************************************

/**
 * Find the point of intersection between two lines.
 * This method uses PVector objects to represent the line end points.
 * @param v0 start of line 1
 * @param v1 end of line 1
 * @param v2 start of line 2
 * @param v3 end of line 2
 * @return a PVector object holding the intersection coordinates else null if no intersection 
 */
public PVector line_line_p(PVector v0, PVector v1, PVector v2, PVector v3){
  final double ACCY   = 1E-30;
  PVector intercept = null;

  double f1 = (v1.x - v0.x);
  double g1 = (v1.y - v0.y);
  double f2 = (v3.x - v2.x);
  double g2 = (v3.y - v2.y);
  double f1g2 = f1 * g2;
  double f2g1 = f2 * g1;
  double det = f2g1 - f1g2;

  if(abs((float)det) > (float)ACCY){
    double s = (f2*(v2.y - v0.y) - g2*(v2.x - v0.x))/ det;
    double t = (f1*(v2.y - v0.y) - g1*(v2.x - v0.x))/ det;
    if(s >= 0 && s <= 1 && t >= 0 && t <= 1)
      intercept = new PVector((float)(v0.x + f1 * s), (float)(v0.y + g1 * s));
  }
  return intercept;
}
  
//******************************************************
//Används inte.
/**
   * Put angle in degrees into [0, 360) range
   */
//  public static float fixAngle(float angle) {
float fixAngle(float angle) {
    while (angle < 0f)
      angle += 360f;
    while (angle >= 360f)
      angle -= 360f;
    return angle;
}

//Används inte.
//public static float relativeAngle(float delta){
float relativeAngle(float delta){
    while (delta < 180f)
      delta += 360f;
    while (delta >= 180f)
      delta -= 360f;
    return delta;
}
