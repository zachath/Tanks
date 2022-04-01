class Team2 extends Team {

  Team2(int team_id, int tank_size, color c, 
    PVector tank0_startpos, int tank0_id, CannonBall ball0, 
    PVector tank1_startpos, int tank1_id, CannonBall ball1, 
    PVector tank2_startpos, int tank2_id, CannonBall ball2) {
    super(team_id, tank_size, c, tank0_startpos, tank0_id, ball0, tank1_startpos, tank1_id, ball1, tank2_startpos, tank2_id, ball2);  

    tanks[0] = new Tank(tank0_id, this, this.tank0_startpos, this.tank_size, ball0);
    tanks[1] = new Tank(tank1_id, this, this.tank1_startpos, this.tank_size, ball1);
    tanks[2] = new Tank(tank2_id, this, this.tank2_startpos, this.tank_size, ball2);

    //this.homebase_x = width - 151;
    //this.homebase_y = height - 351;
  }

  void updateLogic() {
    //for (int i = 0; i < tanks.length; i++) {
    //  tanks[i].updateLogic();
    //}
  }

  //==================================================
  public class Tank1 extends Tank {

    boolean started;
    Sensor locator;
    Sensor us_front; //ultrasonic_sensor front

    Tank1(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
      super(id, team, startpos, diameter, ball);

      us_front = getSensor("ULTRASONIC_FRONT");
      addSensor(us_front);

      started = false;
    }

    public void initialize() {
    }

    // Tanken meddelas om kollision med tree.
    public void message_collision(Tree other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tree)");

      chooseAction();
    }

    // Tanken meddelas om kollision med tanken.
    public void message_collision(Tank other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tank)");

      chooseAction();
    }

    public void arrived() {
      super.arrived(); // Tank
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].arrived()");

      chooseAction();
    }

    public void arrivedRotation() {
      super.arrivedRotation();

      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].arrivedRotation()");
      //moveTo(new PVector(int(random(width)),int(random(height))));
      //moveTo(grid.getRandomNodePosition()); // Slumpmässigt mål.
      moveForward_state(); // Tank
    }

    public void chooseAction() {
      //moveTo(grid.getRandomNodePosition());
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].chooseAction()");
      //resetTargetStates(); // Tank
      //resetAllMovingStates(); // Tank

      float r = random(1, 360);
      rotateTo(radians(r));
    }

    public void readSensorDistance() {
      SensorReading sr = readSensor_distance(us_front);
      //println("1sr.distance(): "+ sr.distance());
      if ((sr.distance() < this.radius) && this.isMoving) {
        if (!this.stop_state) {
          println("Team"+this.team_id+".Tank["+ this.getId() + "] Har registrerat ett hinder. (Tank.readSensorDistance())");
          //stopMoving();
          //stopTurning_state()
          //this.stop_state = true;
          stopMoving_state(); //Tank
          //chooseAction();
        }
      }
    }

    public void updateLogic() {
      //super.updateLogic();


      // Avoid contact with other objects and tanks.
      float threshold = .1f;
      //println("========================================");
      //println("Team"+this.team_id+".Tank["+ this.getId() + "] : " + us_front.readValue(0));
      //if (us_front.readValue(0) < threshold) {
      //  println("*** Team"+this.team_id+".Tank["+ this.getId() + "]: (us_front.readValue(0) < threshold)");
      //}

      // println("Team"+this.team_id+".Tank["+ this.getId() + "] : " + us_front.readValue1());



      if (!started) {
        started = true;
        initialize();

        moveForward_state();
        //moveForward();
      }

      if (!this.userControlled) {
        readSensorDistance();

        //moveForward_state();
        if (this.idle_state) {
          //rotateTo()
          chooseAction();
        }
      }
    }
  }

  //==================================================
  public class Tank2 extends Tank {

    boolean started;

    //*******************************************************
    Tank2(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
      super(id, team, startpos, diameter, ball);

      this.started = false; 

      //this.isMoving = true;
      //moveTo(grid.getRandomNodePosition());
    }

    //*******************************************************
    // Reterera, fly!
    public void retreat() {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].retreat()");
      moveTo(grid.getRandomNodePosition()); // Slumpmässigt mål.
    }

    //*******************************************************
    // Reterera i motsatt riktning (ej implementerad!)
    public void retreat(Tank other) {
      //println("*** Team"+this.team_id+".Tank["+ this.getId() + "].retreat()");
      //moveTo(grid.getRandomNodePosition());
      retreat();
    }

    //*******************************************************
    // Fortsätt att vandra runt.
    public void wander() {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].wander()");
      //rotateTo(grid.getRandomNodePosition());  // Rotera mot ett slumpmässigt mål.
      moveTo(grid.getRandomNodePosition()); // Slumpmässigt mål.
    }


    //*******************************************************
    // Tanken meddelas om kollision med trädet.
    public void message_collision(Tree other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tree)");
      wander();
    }

    //*******************************************************
    // Tanken meddelas om kollision med tanken.
    public void message_collision(Tank other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tank)");

      //moveTo(new PVector(int(random(width)),int(random(height))));
      //println("this.getName());" + this.getName()+ ", this.team_id: "+ this.team_id);
      //println("other.getName());" + other.getName()+ ", other.team_id: "+ other.team_id);

      if ((other.getName() == "tank") && (other.team_id != this.team_id)) {
        if (this.hasShot && (!other.isDestroyed)) {
          println("["+this.team_id+":"+ this.getId() + "] SKJUTER PÅ ["+ other.team_id +":"+other.getId()+"]");
          fire();
        } else {
          retreat(other);
        }

        rotateTo(other.position);
        //wander();
      } else {
        wander();
      }
    }
    
    //*******************************************************  
    // Tanken meddelas om den har kommit hem.
    public void message_arrivedAtHomebase() {
      //println("*** Team"+this.team_id+".Tank["+ this.getId() + "].message_isAtHomebase()");
      println("! Hemma!!! Team"+this.team_id+".Tank["+ this.getId() + "]");
    }

    //*******************************************************
    // används inte.
    public void readyAfterHit() {
      super.readyAfterHit();
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].readyAfterHit()");

      //moveTo(grid.getRandomNodePosition());
      wander();
    }

    //*******************************************************
    public void arrivedRotation() {
      super.arrivedRotation();
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].arrivedRotation()");
      //moveTo(new PVector(int(random(width)),int(random(height))));
      arrived();
    }

    //*******************************************************
    public void arrived() {
      super.arrived();
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].arrived()");

      //moveTo(new PVector(int(random(width)),int(random(height))));
      //moveTo(grid.getRandomNodePosition());
      wander();
    }

    //*******************************************************
    public void updateLogic() {
      super.updateLogic();

      if (!started) {
        started = true;
        moveTo(grid.getRandomNodePosition());
      }

      if (!this.userControlled) {

        //moveForward_state();
        if (this.stop_state) {
          //rotateTo()
          wander();
        }

        if (this.idle_state) {
          wander();
        }
        
        
      }
    }
  }

  //==================================================
  public class Tank3 extends Tank {

    PVector cr = new PVector();
    float wandertheta;
    float maxforce;

    Tank3(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
      super(id, team, startpos, diameter, ball);

      this.wandertheta = 0;
      this.maxforce = 0.05;
      this.stop_state = false;
    }

    //--------------------
    // A method that calculates and applies a steering force towards a target
    // STEER = DESIRED MINUS VELOCITY
    void seek(PVector target) {
      PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target

      // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);


      // Steering = Desired minus Velocity
      PVector steer = PVector.sub(desired, velocity);

      steer.limit(maxforce);  // Limit to maximum steering force
      //println("steer: " + steer.getHeading());

      if (steer.heading() < 0) {
        this.turning_right_state = false;
        this.turning_left_state = true;
      } else
        if (steer.heading() > 0) {
          this.turning_right_state = true;
          this.turning_left_state = false;
        }

      //applyForce(steer);
    }

    void wander() {
      float wanderR = 25;         // Radius for our "wander circle"
      float wanderD = 200;//80         // Distance for our "wander circle"
      float change = 0.3;
      wandertheta += random(-change, change);     // Randomly change wander theta

      // Now we have to calculate the new position to steer towards on the wander circle
      PVector circlepos = new PVector();
      circlepos.set(velocity);    // Start with velocity
      circlepos.normalize();            // Normalize to get heading
      circlepos.mult(wanderD);          // Multiply by distance
      circlepos.add(position);               // Make it relative to boid's position

      float h = velocity.heading();        // We need to know the heading to offset wandertheta
      //float h = this.heading;        // We need to know the heading to offset wandertheta

      PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h), wanderR*sin(wandertheta+h));
      PVector target = PVector.add(circlepos, circleOffSet);

      seek(target);

      // Render wandering circle, etc.
      if (debugOn) drawWanderStuff(position, circlepos, target, wanderR);
    }

    // A method just to draw the circle associated with wandering
    void drawWanderStuff(PVector position, PVector circle, PVector target, float rad) {
      stroke(0);
      noFill();
      ellipseMode(CENTER);
      ellipse(circle.x, circle.y, rad*2, rad*2);

      ellipse(circle.x, circle.y, 10, 10);
      //ellipse(position.x,position.y,10,10);

      ellipse(target.x, target.y, 4, 4);
      line(position.x, position.y, circle.x, circle.y);
      line(circle.x, circle.y, target.x, target.y);
    }
    //--------------------

    void checkFront_sensor() {
    }

    void checkEnvironment_sensor() {
      float tempx = 0;
      PVector w = new PVector(0, 0);
    }

    public void updateLogic() {
      super.updateLogic();

      if (!this.userControlled) {
        checkEnvironment_sensor();


        if (!this.stop_state) {
          moveForward_state();
          wander();

          //println("heading1: " + this.heading);
          //println("velocity1: " + this.velocity); 
          //println("velocityheading1: " + this.velocity.getHeading()); 
          //this.heading = this.velocity.getHeading();
        }
      }
    }
  }
}
