//Michael Foussianis
//Zacharias Thorell
public class AgentTank extends Tank {
    private final static int LOS_LENGTH = 5;
    boolean started;
    
    int currentCol, currentRow;
    
    boolean searching;
    boolean homeBound;
    
    KnowledgeBase internalKnowledge;
    LinkedList<Node> pathHome = new LinkedList<>();
    
    AgentTank(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
      super(id, team, startpos, diameter, ball);
      started = false;
      internalKnowledge = new KnowledgeBase(team);
   
      Node currentNode = grid.getNearestNode(startpos);
      team.knowledgeBase.markVisit(currentNode);
      team.knowledgeBase.connectNodes(currentNode, grid.getNeighbours(currentNode));
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
      LOS();
      if(team.communicationHandler.connectionIsUp()) {
        team.knowledgeBase.checkNeighbours(n);
      }
      else {
        internalKnowledge.checkNeighbours(n);
      }
    }
  }
    
    public void initialize() {
    }
    
    //Random walk.
    public void patrol() {
      Node currentNode = grid.getNearestNode(getRealPosition());
      
      LOS();
      
      ArrayList<Node> neighbouringNodes = grid.getNeighbours(currentNode);
      ArrayList<Node> unvisitedNeighbours = new ArrayList<>();
      
      //Kontrollerar om man kan kommunicera med laget, baserat på det så används lagets KnowledgeBase eller tankens egna.
      if(team.communicationHandler.connectionIsUp()) {
          team.knowledgeBase.checkNeighbours(currentNode);
        }
        
        else {
          internalKnowledge.checkNeighbours(currentNode);
        }
      
      for (Node n : neighbouringNodes) {
        lookForTanks(n);
        if(!searching) {
          return;
        }
        
        //Kontrollerar om man kan kommunicera med laget, baserat på det så används lagets KnowledgeBase eller tankens egna.
        if(team.communicationHandler.connectionIsUp()) {
          if (!team.knowledgeBase.visited[n.col][n.row]) {
            unvisitedNeighbours.add(n);
          }
        }
        
        else {
          if (!internalKnowledge.visited[n.col][n.row]) {
            unvisitedNeighbours.add(n);
          }
        }
      }
      
      println(String.format("Currently at: %d : %d", currentNode.col, currentNode.row));
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

    //Line Of Sight, straight ahead in the direction the tank is facing
    public void LOS() {
      Direction tankDirection = Compass.getDirection(this);
      Node currentNode = grid.getNearestNode(getRealPosition());
      int newCol = currentNode.col;
      int newRow = currentNode.row;
      
      for (int i = 0; i < LOS_LENGTH; i++) {
        newCol += tankDirection.colStep;
        newRow += tankDirection.rowStep;
        
        //Skip out of bounds.
        if(grid.outOfBounds(newCol, newRow)) {
          continue;
        }
        
        Node seenNode = grid.nodes[newCol][newRow];
        
        //Kontrollerar om man kan kommunicera med laget, baserat på det så används lagets KnowledgeBase eller tankens egna.
        KnowledgeBase tmp;
        if(team.communicationHandler.connectionIsUp()) {
          tmp = team.knowledgeBase;
        }
        else {
          tmp = internalKnowledge;
        }
        
        if (!tmp.visited[seenNode.col][seenNode.row]) {
          tmp.markSeen(seenNode);
          tmp.LOSCheckNeighbours(seenNode);
        }
        
        lookForTanks(seenNode);
      }
    }
    
    public void lookForTanks(Node n) {
      if (n.content() instanceof Tank) {
          Tank other = (Tank) n.content();
          
          if (other.team.id != this.team.id) {
            println("Found enemy tank, stoping search.");
            
            if (team.communicationHandler.connectionIsUp()) {
              println("notifiying!");
              team.notifyTeam();
            }
            else {
              this.notifyTank();
            }
          }
        }
    }
    
    //Notifies the tank that it should be going home.
    public void notifyTank() {
      println(id + ": findHome");
      searching = false;
      homeBound = true;
      //Kontrollerar om man kan kommunicera med laget, baserat på det så används lagets KnowledgeBase eller tankens egna.
      if(team.communicationHandler.connectionIsUp()) {
        pathHome = team.knowledgeBase.findPathHome(grid.getNearestNode(getRealPosition()));
      }
      else {
        pathHome = internalKnowledge.findPathHome(grid.getNearestNode(getRealPosition()));
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
        "idle_state : "+this.idle_state +"\n"+
        "internalGraph size : "+internalKnowledge.graph.keySet().size()+"\n"+
        "teamGraph size : "+team.knowledgeBase.graph.keySet().size()+"\n"+
        "communication status :" + team.communicationHandler.connectionIsUp()+"\n"+
        "DIRECTION : "+Compass.getDirection(this) +"\n"
      , width - 145, 35 );
  }
  }
