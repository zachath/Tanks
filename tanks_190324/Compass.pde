static class Compass {
    enum Direction {
        NORTH(-112.5f, -67.5f),
        NORTHEAST(-67.5f, -22.5f),
        NORTHWEST(-157.5f, -112.5f),
        EAST(-22.5f, 22.5f),
        SOUTHEAST(22.5f, 67.5f),
        SOUTH(67.5f, 112.5f),
        SOUTHWEST(112.5f, 157.5f),
        WEST(157.5f, -157.5f);
        
        public final float min;
        public final float max;

        private Direction(float min, float max) {
            this.min = min;
            this.max = max;
        }
    }
    
    public static Direction getDirection(Tank tank) {
      float tankHeading = tank.getHeadingInDegrees();
      
      if(Direction.NORTH.min <= tankHeading && tankHeading < Direction.NORTH.max) {
        return Direction.NORTH;
      }
      
      else if(Direction.NORTHEAST.min <= tankHeading && tankHeading < Direction.NORTHEAST.max) {
        return Direction.NORTHEAST;
      }
      
      else if(Direction.NORTHWEST.min <= tankHeading && tankHeading < Direction.NORTHWEST.max) {
        return Direction.NORTHWEST;
      }
      
      else if(Direction.EAST.min <= tankHeading && tankHeading < Direction.EAST.max) {
        return Direction.EAST;
      }
      
      else if(Direction.SOUTHEAST.min <= tankHeading && tankHeading < Direction.SOUTHEAST.max) {
        return Direction.SOUTHEAST;
      }
      
      else if(Direction.SOUTH.min <= tankHeading && tankHeading < Direction.SOUTH.max) {
        return Direction.SOUTH;
      }
      
      else if(Direction.SOUTHWEST.min <= tankHeading && tankHeading < Direction.SOUTHWEST.max) {
        return Direction.SOUTHWEST;
      }
      
      else {
        return Direction.WEST;
      }
    }
}
