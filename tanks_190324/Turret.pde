class Turret {
  PImage img;
  float rotation_speed;
  float cannon_length;
  
  PVector position;
  //PVector velocity;
  //PVector acceleration;
  // Variable for heading!
  float heading;
  
  
  Turret(float cannon_length) {
    //this.img = loadImage("gunTurret2.png");
    this.position = new PVector(0.0, 0.0);
    
    this.cannon_length = cannon_length;
    this.heading = 0.0;
    this.rotation_speed = radians(1);
  }
  
  void turnLeft() {
    this.heading -= this.rotation_speed;
  }
  
  void turnRight() {
    this.heading += this.rotation_speed;
  }
  
  void drawTurret(){
    strokeWeight(1);
    //fill(204, 50, 50);
    ellipse(0, 0, 25, 25);
    strokeWeight(3);
    line(0, 0, this.cannon_length, 0);
  }
  
  void fire() {
    
  }
  
  void display() {  
    this.position.x = cos(this.heading);
    this.position.y = sin(this.heading);
    
    rotate(this.heading);
    //image(img, 20, 0);
    drawTurret();
    
  }
}
