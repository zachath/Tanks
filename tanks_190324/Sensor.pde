class SensorReading {
  float distance;
  float heading;
  Sprite obj;
  
  SensorReading() {
    obj = null;
    distance = 0F;
    heading = 0F;
  }
  
  SensorReading(Sprite _obj, float _distance, float _heading) {
    obj = _obj;
    distance = _distance;
    heading = _heading;
  }
  
  Sprite obj() {
    return obj; 
  }
  
  float getHeading() {
   return heading; 
  }
  
  float distance() {
   return distance; 
  }
  
  
  
  
}

// Används ännu inte.
class Sensor{

  protected Tank tank;
  boolean disabled;

  Sensor(Tank t){
    this.tank = t;
    this.disabled = false;
  }

  protected Tank getTank(){
    return tank;
  }
  
  boolean disabled(){
    return this.disabled;
  }

  /*
    Performs readings
  */
  public float[] readValues(){
    return null;
  }

  /*
    Performs readings and returns the value at index
  */
 //  public PVector readValue(){
 //   return new PVector();
 //}
  
 //public float readValue1(){
 //   return 0.0;
 //}
 
  public SensorReading readValue(){
    return new SensorReading();
  }
  
  public float readValue(int index){
    return readValues()[index];
  }

  /**
   * Applies random noise to a given value
   *
   * @return The new computed reading
   */
  protected float getReadingAfterNoise(float reading, float noise) {
    float addedNoise = (float) Math.random() * noise - noise / 2f;
    return reading + addedNoise;
  }
}
