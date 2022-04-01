//Används ännu inte
//import processing.core.*;

class SensorCompass extends Sensor{

  // Random noise applyed to the final reading
  private static final int NOISE_AMOUNT = 3;

  // Interval to read the sensor in seconds
  private static final float READ_INTERVAL = 0.01f;

  float[] values = new float[1];

  //SensorCompass(GameSimulator g, Tank t){
  //  super(g, t);
  //}
  SensorCompass(Tank t){
    super(t);
  }

  float lastRead = 0;
  public float[] readValues(){
    //if(game.getTime() >= lastRead + READ_INTERVAL)
    if(getTime() >= lastRead + READ_INTERVAL)
      doReading();

    return values;
  }

  private void doReading(){
    Tank thisTank = getTank();

    //float orientation = (float)Math.toDegrees(thisTank.orientation);
    //float orientation = (float)Math.toDegrees(thisTank.heading);
    float orientation = (float) thisTank.getHeadingInDegrees(); Math.toDegrees(thisTank.heading);

    // Fix orientation (from 0-359)
    int multiples = (int)(orientation / 360);
    orientation = orientation - multiples * 360;
    //orientation = MathUtil.fixAngle(orientation);
    orientation = fixAngle(orientation);

    values[0] = getReadingAfterNoise(orientation, NOISE_AMOUNT);
  }

}
