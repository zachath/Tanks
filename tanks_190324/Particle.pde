class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    this.acceleration = new PVector(0, 1);
    this.position = new PVector().set(l);
    this.velocity = new PVector(random(-1, 1), random(-1, 1));
    //position = l.get();
    
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    //velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 7.0;
  }

  // Method to display
  void display() {
    //println("lifespan: " + lifespan);
    stroke(0, lifespan);
    strokeWeight(2);
    fill(127, lifespan);
    ellipse(position.x, position.y, 100-lifespan, 100-lifespan);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}
