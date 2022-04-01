void keyPressed() {
  if (userControl) {

    if (key == CODED) {
      switch(keyCode) {
      case LEFT:
        //myTank1_snd.engineStart();
        left = true;
        break;
      case RIGHT:
        //myTank_snd.engineStart();
        right = true;
        break;
      case UP:
        //myTank_snd.engineStart();
        up = true;
        break;
      case DOWN:
        //myTank_snd.engineStart();
        down = true;
        break;
      case ALT:
        // turret.
        alt_key = true;
        break;
      }
    }
    if (key == ' ') {
      //myAudio.shot();
      //myAudio.blast();
      //myTank1.fire(); 
      println("keyPressed SPACE");
      allTanks[tankInFocus].fire();
    }
  }

  if (key == 'c') {
    userControl = !userControl;
    
//    allTanks[tankInFocus].stopMoving_state();
//    allTanks[tankInFocus].stopTurning_state();
//    allTanks[tankInFocus].stopTurretTurning_state();
    
    if (!userControl) {
      allTanks[tankInFocus].releaseControl();
        
    } else {
      allTanks[tankInFocus].takeControl();
    }
  }
  
  if (key == 'p') {
    pause = !pause;
    if (pause) {
      timer.pause();
    } else {
      timer.resume();
    }
  }

  if (key == 'd') {
    debugOn = !debugOn;
  }
}

void keyReleased() {
  if (userControl) {

    if (key == CODED) {
      switch(keyCode) {
      case LEFT:
        //myTank_snd.engineStop();
        left = false;
        allTanks[tankInFocus].stopTurning_state();
        break;
      case RIGHT:
        //myTank_snd.engineStop();
        right = false;
        allTanks[tankInFocus].stopTurning_state();
        break;
      case UP:
        //myTank_snd.engineStop();
        up = false;
        allTanks[tankInFocus].stopMoving_state();
        break;
      case DOWN:
        //myTank_snd.engineStop();
        down = false;
        allTanks[tankInFocus].stopMoving_state();
        break;
      case ALT:
        // turret.
        alt_key = false;
        allTanks[tankInFocus].stopTurretTurning_state();
      }
    }
  }
}

public void keyTyped() {

  if (userControl) {
    switch(key) {
    case '1':
      allTanks[tankInFocus].releaseControl();
      tankInFocus = 1;
      allTanks[tankInFocus].takeControl();
      break;
    case '2':
      allTanks[tankInFocus].releaseControl();
      tankInFocus = 2;
      allTanks[tankInFocus].takeControl();
      break;
    case '3':
      allTanks[tankInFocus].releaseControl();
      tankInFocus = 3;
      allTanks[tankInFocus].takeControl();
      break;
    case '4':
      allTanks[tankInFocus].releaseControl();
      tankInFocus = 4;
      allTanks[tankInFocus].takeControl();
      break;
    case '5':
      allTanks[tankInFocus].releaseControl();
      tankInFocus = 5;
      allTanks[tankInFocus].takeControl();
      break;
    case '0':
      allTanks[tankInFocus].releaseControl();
      tankInFocus = 0;
      allTanks[tankInFocus].takeControl();
      break;
    }
  }
}
