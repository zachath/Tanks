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
    
    public Direction getDirection(Tank tank) {
      float tankHeading = tank.getHeadingInDegrees();
      
      if(NORTH.min <= tankheading < NORTH.max) {
        return NORTH;
      }
      
      else if(NORTHEAST.min <= tankheading < NORTHEAST.max) {
        return NORTHEAST;
      }
      
      else if(NORTHWEST.min <= tankheading < NORTHWEST.max) {
        return NORTHWEST;
      }
      
      else if(EAST.min <= tankheading < EAST.max) {
        return EAST;
      }
      
      else if(SOUTHEAST.min <= tankheading < SOUTHEAST.max) {
        return SOUTHEAST;
      }
      
      else if(SOUTH.min <= tankheading < SOUTH.max) {
        return SOUTH;
      }
      
      else if(SOUTHWEST.min <= tankheading < SOUTHWEST.max) {
        return SOUTHWEST;
      }
      
      else if(WEST.min <= tankheading < WEST.max) {
        return WEST;
      }
    }
}
