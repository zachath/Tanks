static class Compass {
    
    
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

enum Direction {
        NORTH(-112.5f, -67.5f, 0, -1, "North"),
        NORTHEAST(-67.5f, -22.5f, 1, -1, "Northeast"),
        NORTHWEST(-157.5f, -112.5f, -1, -1, "Northwest"),
        EAST(-22.5f, 22.5f, 1, 0, "East"),
        SOUTHEAST(22.5f, 67.5f, 1, 1, "Southeast"),
        SOUTH(67.5f, 112.5f, 0, 1, "South"),
        SOUTHWEST(112.5f, 157.5f, -1, 1, "Southwest"),
        WEST(157.5f, -157.5f, -1, 0, "West");
        
        public final float min;
        public final float max;
        public final int colStep;
        public final int rowStep;
        public final String name;

        private Direction(float min, float max, int colStep, int rowStep, String name) {
            this.min = min;
            this.max = max;
            this.colStep = colStep;
            this.rowStep = rowStep;
            this.name = name;
        }
    }
