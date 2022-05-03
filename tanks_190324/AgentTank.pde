public class AgentTank extends Tank {
    private final static int LOS_LENGTH = 5;
    boolean started;
    Node startNode;
    
    int currentCol, currentRow;
    
    boolean searching;
    boolean homeBound;
    boolean communicationPossible;
    
    Graph internalGraph;
    LinkedList<Node> pathHome = new LinkedList<>();
    
    AgentTank(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
      super(id, team, startpos, diameter, ball);
      started = false;
      internalGraph = new Graph(team);
      communicationPossible = true;
   
      startNode = grid.getNearestNode(startpos);
      if(communicationPossible) {
        team.graph.markVisit(startNode);
        team.graph.connectNodes(startNode, team.graph.getNeighbours(startNode));
      }
      else {
        internalGraph.markVisit(startNode);
        internalGraph.connectNodes(startNode, internalGraph.getNeighbours(startNode));
      }
    }
    
    void moveTo(PVector coord) {
    if (!isImmobilized) {
      this.idle_state = false;
      this.isMoving = true;
      this.stop_state = false;

      this.targetPosition.set(coord);
      this.hasTarget = true;
    }
    
    if(userControlled) {
      Node n = grid.getNearestNode(coord);
      
      if(communicationPossible) {
        team.graph.connectNodes(n, team.graph.getNeighbours(n));
        //team.graph.markVisit(n);
        println("CONNECTED NODES");
      }
      else {
        internalGraph.connectNodes(n, internalGraph.getNeighbours(n));
      }
    }
  }
    
    public void initialize() {
    }
    
    //Random walk.
    public void patrol() {
      startNode = grid.getNearestNode(getRealPosition());
      
      LOS();
      
      ArrayList<Node> neighbouringNodes;
      if(communicationPossible) {
        neighbouringNodes = team.graph.getNeighbours(startNode);
      }
      else {
        neighbouringNodes = internalGraph.getNeighbours(startNode);
      }
      
      ArrayList<Node> unvisitedNeighbours = new ArrayList<>();
      
      for (Node n : neighbouringNodes) {
        lookForTanks(n);
        if(!searching) {
          return;
        }
        
        if(communicationPossible) {
          if (!team.graph.visited[n.col][n.row]) {
            unvisitedNeighbours.add(n);
          }
        }
        
        else {
          if (!internalGraph.visited[n.col][n.row]) {
            unvisitedNeighbours.add(n);
          }
        }
      }
      
      println("Neighbours: " + neighbouringNodes.size());
      println("Unvisited: " + unvisitedNeighbours.size());
      
      println(String.format("Currently at: %d : %d", startNode.col, startNode.row));
      if (unvisitedNeighbours.size() == 0) {
        Node node = neighbouringNodes.get((int) random(neighbouringNodes.size()));
        println(String.format("Going to: %d : %d", node.col, node.row));
        moveTo(node.position);
      }
      else {
        Node node = unvisitedNeighbours.get((int) random(unvisitedNeighbours.size()));
        println(String.format("Going to: %d : %d", node.col, node.row));
        moveTo(node.position);
      }
    }

    public void LOS() {
      Direction tankDirection = Compass.getDirection(this);
      int newCol = startNode.col;
      int newRow = startNode.row;
      
      for (int i = 0; i < LOS_LENGTH; i++) {
        println(String.format("Direction: %s, Iteration: %d", tankDirection.name, i));
        newCol += tankDirection.colStep;
        newRow += tankDirection.rowStep;
        
        //Skip out of bounds.
        if(grid.outOfBounds(newCol, newRow)) {
          continue;
        }
        
        Node seenNode = grid.nodes[newCol][newRow];
        
        Graph tmp;
        if(communicationPossible) {
          tmp = team.graph;
        }
        else {
          tmp = internalGraph;
        }
        
        if (!tmp.visited[seenNode.col][seenNode.row]) {
          tmp.markSeen(seenNode);
          tmp.checkNeighbours(seenNode);
        }
        
        lookForTanks(seenNode);
      }
    }
    
    public void lookForTanks(Node n) {
      if (n.content() instanceof Tank) {
          Tank other = (Tank) n.content();
          
          if (other.team.id != this.team.id) {
            println("Found enemy tank, stoping search.");
            
            if (communicationPossible) {
              team.notifyTeam();
            }
            else {
              this.notifyTank();
            }
          }
        }
    }
    
    public void notifyTank() {
      println(id + ": findHome");
      searching = false;
      homeBound = true;
      if(communicationPossible) {
        pathHome = team.graph.findPathHome(grid.getNearestNode(getRealPosition()));
      }
      else {
        pathHome = internalGraph.findPathHome(grid.getNearestNode(getRealPosition()));
      }
    }
    
    //DS9 reference.
    public void moveAlongHome() {
      if (!pathHome.isEmpty()) {
        moveTo(pathHome.poll().position);
      }
      else {
        homeBound = false;
        println("Should be home.");
      }
    }
    
    public void message_collision(Tank other) {
      if (other.team.id != this.team.id) {
        println("Found enemy tank, stopping search.");
        searching = false;
      }
    }
    
    public void updateLogic() {
      if (!started) {
        started = true;
        searching = true;
        patrol();
      }
      
      

      if (!this.userControlled) {

        if (this.idle_state && searching) {
          print("Idle and searching");
          patrol();
        }
        else if (this.idle_state && homeBound) {
          moveAlongHome();
        }
      }
    }
    
    void displayInfo() {
      fill(230);
      rect(width - 151, 0, 150, 300);
      strokeWeight(1);
      fill(255, 0, 0);
      stroke(255, 0, 0);
      textSize(10);
      text("id: "+this.id+"\n"+
        "health: "+this.health+"\n"+
        "position: ("+(int)this.position.x +","+(int)this.position.y+")"+"\n"+
        "isMoving: "+this.isMoving+"\n"+
        "isSpinning : "+this.isSpinning +"\n"+
        "remaining_turns: "+this.remaining_turns +"\n"+
        "isReady : "+this.isReady +"\n"+
        "hasTarget : "+this.hasTarget +"\n"+
        "stop_state : "+this.stop_state +"\n"+
        "stop_turning_state : "+this.stop_turning_state +"\n"+
        "idle_state : "+this.idle_state +"\n"+
        "isDestroyed : "+this.isDestroyed +"\n"+
        "isImmobilized : "+this.isImmobilized +"\n"+
        "targetHeading : "+this.targetHeading +"\n"+
        "DIRECTION : "+Compass.getDirection(this) +"\n"+
        "headingInDegrees : "+getHeadingInDegrees() + "\n"+
        "heading_saved: "+this.heading_saved +"\n"
      , width - 145, 35 );
  }
  }
