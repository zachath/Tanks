void checkForInput() {
  if (userControl) {

    if (alt_key) {
      //println("alt_key: " + alt_key);
      if (left) {
        allTanks[tankInFocus].turnTurretLeft_state();
      } else if (right) {
        allTanks[tankInFocus].turnTurretRight_state();
      }
    } else 
    if (!alt_key) {

      if (left) {
        allTanks[tankInFocus].turnLeft_state();
      } else if (right) {
        allTanks[tankInFocus].turnRight_state();
      }

      if (up) {
        allTanks[tankInFocus].moveForward_state();
      } else if (down) {
        allTanks[tankInFocus].moveBackward_state();
      }

      if (!(up || down)) {
        //allTanks[tankInFocus].deaccelarate();
        //allTanks[tankInFocus].stopMoving_state();
      }
      if (!(right || left)) {
        //allTanks[tankInFocus].deaccelarate();
        //allTanks[tankInFocus].stopTurning_state();
      }
    }

    if (!(alt_key && (left || right))) {
      //allTanks[tankInFocus].stopTurretTurning_state();
    }

    if (mouse_pressed) {
      println("if (mouse_pressed)");
      //allTanks[tankInFocus].spin(3);
      int mx = mouseX;
      int my = mouseY;

      setTargetPosition(new PVector(mx, my));

      mouse_pressed = false;
    }
  }
}
