// Används ännu inte.
//import processing.core.*;

/**
 * Simulates an ultrasonic distance sensor.
 * Readings are synchronous and blocking.
 */

class SensorDistance extends Sensor{

  // Random noise applied to the final reading
  private static final float NOISE_AMOUNT = .01f;

  // Angle in degrees between tank's heading and sensor heading
  public float localOrientation = 0f;

  //SensorDistance(GameSimulator g, Tank r, float localOrientation) {
  //  super(g, r);
  //  this.localOrientation = localOrientation;
  //}
  SensorDistance(Tank t, float localOrientation) {
    super(t);
    this.localOrientation = localOrientation;
  }
  
  public boolean canSee(PVector obj) {
    /*
     PVector toTarget = new PVector(obj
     
     //--------
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
     
     
     
     
     //-------
      PVector force = PVector.fromAngle(this.heading);
        force.mult(10);
        this.ball.applyForce(force);
        
        
     //-------
      // Kontroll om att tanken inte "fastnat" i en annan tank. 
          distanceVect = PVector.sub(other.position, this.position);
          distanceVectMag = distanceVect.mag();
          if (distanceVectMag < minDistance) {
            println("FAST I ETT TRÄD");  
          }
        
    */
    
    return false;
  }
  
   //******************************************************
  // Returnera koordinaten som PVector, där tankens heading korsar kanterna på fönstret.
  public PVector readValue1(){
    
    PVector v11, v12, v21, v22, h11, h12, h21, h22;
    PVector t = new PVector(); 
    t = tank.position.copy();
    float angle = tank.heading; // - PI/2;
    PVector force = new PVector(cos(angle),sin(angle));
    force.mult(1000);
    t.add(force);
    
    v11 = new PVector(0, 0);          // vänster kant
    v12 = new PVector(0, height);
    h11 = new PVector(0, 0);          // övre kant
    h12 = new PVector(width, 0);
    v21 = new PVector(width, 0);      // höger kant
    v22 = new PVector(width, height);
    h21 = new PVector(0 , height);    // nerdre kant
    h22 = new PVector(width, height);
   
    
    // Returnera koordinaten som PVector, där tankens heading korsar kanterna på fönstret.
    PVector pvec = new PVector();
    
    pvec = line_line_p(tank.position, t, v21, v22); // höger kant.
    if (pvec == null) {
      pvec = line_line_p(tank.position, t, v11, v12); // vänster kant.
    }
    if (pvec == null) {
      pvec = line_line_p(tank.position, t, h11, h12); // övre kant.
    }
    if (pvec == null) {
      pvec = line_line_p(tank.position, t, h21, h22); // nedre kant.
    }
    
    return pvec;
  }

  
  //******************************************************
  // Returnera avståndet till kanten i tankens riktning. //<>//
  public SensorReading readValue(){
    
    PVector v11, v12, v21, v22, h11, h12, h21, h22;
    PVector tpos_cp = new PVector(); 
    tpos_cp = tank.position.copy();
    float angle = tank.heading; // - PI/2;
    PVector tpos = tank.position;
    PVector force = new PVector(cos(angle),sin(angle));
    force.mult(1000);
    tpos_cp.add(force);
    
    v11 = new PVector(0, 0);          // vänster kant
    v12 = new PVector(0, height);
    h11 = new PVector(0, 0);          // övre kant
    h12 = new PVector(width, 0);
    v21 = new PVector(width, 0);      // höger kant
    v22 = new PVector(width, height);
    h21 = new PVector(0 , height);    // nedre kant
    h22 = new PVector(width, height);
   
    
    // Returnera koordinaten som PVector, där tankens heading korsar kanterna på fönstret.
    PVector pvec = new PVector();
    
    pvec = line_line_p(tpos, tpos_cp, v21, v22); // höger kant.
    
    if (pvec == null) {
      pvec = line_line_p(tpos, tpos_cp, v11, v12); // vänster kant.
    }
    if (pvec == null) {
      pvec = line_line_p(tpos, tpos_cp, h11, h12); // övre kant.
    }
    if (pvec == null) {
      pvec = line_line_p(tpos, tpos_cp, h21, h22); // nedre kant.
    }
    
    // Om pvec fortfarande är null, så ge den ett värde.
    if (pvec == null) {
      pvec = tpos;  
    }
    
    // Get distances between the tanks components
    PVector distanceVect = PVector.sub(pvec, tpos);

    // Calculate magnitude of the vector separating the tanks
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before the tank are touching border
    float minDistance = tank.radius * 2;
    
    // Skapa ett nytt SensorReading objekt.
    Sprite obj = new Sprite(); 
    obj.position = pvec; 
    
    
    SensorReading reading = new SensorReading(
      obj, 
      distanceVectMag - minDistance,
      angle);
    
    
    //return (distanceVectMag - minDistance);
    return reading;
  }

  //******************************************************
  /**
   * @return float array of size 1 with the current distance
   */
  // TODO this should fail to read based on the angle between ray and surface
  public float[] readValues() {
    PVector origin = tank.getRealPosition();
    //float direction = tank.getHeading() + (float) Math.toRadians(localOrientation);
    float direction = tank.getHeading();


    // use border of tank
    PVector v = PVector.fromAngle(direction);
    v.setMag(tank.getRadius());
    //origin.add(v);

    //float dist = game.closestSimulatableInRay(tank, origin, direction);
    
    //dist = getReadingAfterNoise(dist, NOISE_AMOUNT);
    float dist = 3.14; // Dummy temp. 

    float[] values = new float[1];
    values[0] = Math.max(dist, 0);
    return values;
  }

}
