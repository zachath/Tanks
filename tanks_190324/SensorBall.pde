// Används ännu inte.
//import processing.core.*;

class SensorBall extends Sensor{

  float[] values = new float[2];
  float sensorLimit = 1f;

  SensorBall(Tank t){
    super(t);
  }

  float lastRead = 0;
  //public float[] readValues(){
  //  // Avoid multiple readings within 100ms
  //  if(game.getTime() >= lastRead + 0.1f)
  //    doReading();

  //  return values;
  //}
  public float[] readValues(){
    // Avoid multiple readings within 100ms
    if(getTime() >= lastRead + 0.1f)
      doReading();

    return values;
  }

  private void doReading(){
    Tank thisTank = getTank();

    
    for (int i = 0; i < allShots.length; i++) {
      CannonBall ball = allShots[i];
    
      // Check if ball is turned off
      if(!ball.isVisible){
        values[0] = 0;
        values[1] = 0;
        return;
      }
  
      // Find relative distance from Ball to Tank
      PVector dist = PVector.sub(ball.position, thisTank.position);
      dist.rotate(-thisTank.getHeading());
  
      // index 0 contains the Angle of the ball
      values[0] = (float)Math.toDegrees(dist.heading());
      // index 1 contains the distance to the ball
      values[1] = (float)Math.min(dist.mag(), sensorLimit);
    }
  }

}
