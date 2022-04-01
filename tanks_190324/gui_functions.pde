// Initiera användargränssnittet.
// Används inte.
void setGUI() {
  println("*** setGUI()- Användargränsnittet skapas.");

}
//**************************************************
// Gör så att allt i användargränssnittet (GUI) visas.
void showGUI() {
  //println("*** showGUI()");

  textSize(14);
  fill(30);
  text("Team1: "+teams[0].numberOfHits, 10, 20);
  text("Team2: "+teams[1].numberOfHits, width-100, 20);
  textSize(24);
  text(remainingTime, width/2, 25);
  textSize(14);
  
  
  if (userControl) {
    // Draw an ellipse at the mouse position
    PVector mouse = new PVector(mouseX, mouseY);
    fill(200);
    stroke(0);
    strokeWeight(2);
    ellipse(mouse.x, mouse.y, 48, 48);
    //grid.displayNearestNode(mouseX, mouseY);
  }


  if (debugOn) {
    // Visa framerate.
    fill(30);
    text("FPS:"+ floor(frameRate), 10, height-10);

    // Visa grid.
    fill(205);
    gridDisplay();

    // Visa musposition och den närmaste noden.
    fill(255, 92, 92);
    ellipse(mouseX, mouseY, 5, 5);
    grid.displayNearestNode(mouseX, mouseY);
  }
  
  if (pause) {
    textSize(36);
    fill(30);
    text("Paused!", width/2-100, height/2);
  }
  
  if (gameOver) {
    textSize(36);
    fill(30);
    text("Game Over!", width/2-100, height/2);
  }
}
//**************************************************
// Gör så att textfälten visas och uppdateras. 
// Används inte.
void showOutput() {
}

void displayTrees() {
  for (int i = 0; i<allTrees.length; i++) {
    allTrees[i].display();
  }
}


void gridDisplay() {
  strokeWeight(0.3);

  grid.display();
}

void updateTanksDisplay() {
  //for (int i = 0; i < allTanks.length; i++) {
  //  allTanks[i].display();
  //}
  for (Tank tank : allTanks) {
    tank.display();
  }
}

void updateShotsDisplay() {
  for (int i = 0; i < allShots.length; i++) {
    allShots[i].display();
  }
}
