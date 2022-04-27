public class AgentTank extends Tank {
    boolean started;
    Node currentNode;
    
    int currentCol, currentRow;
    
    boolean searching;
    boolean homeBound;
    
    HashMap<Node, ArrayList<Node>> internalGraph = new HashMap<>();
    Node homeNode;
    LinkedList<Node> pathHome = new LinkedList<>();
    
    //Neighbouring nodes.
    int[] col_directions = {0, 0, 1, -1, -1, -1, 1, 1};
    int[] row_directions = {-1, 1, 0, 0, -1, 1, -1, 1};
    
    AgentTank(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
      super(id, team, startpos, diameter, ball);
      started = false;
      
      //startposition = homenode
      currentNode = grid.getNearestNode(startpos);
      homeNode = currentNode;
      team.visited[currentNode.col][currentNode.row] = true;
      connectNodes(currentNode, getNeighbours(currentNode));
      
      connectHomeBaseNodes();
      
    }
    
    //Lägg till alla hembasnoder till "minnet"
    void connectHomeBaseNodes() {
      for(Node[] nArr : grid.nodes) {
        for(Node n : nArr) {
          if(isHomeNode(n)) {
            markVisit(n);
            connectNodes(n, getNeighbours(n));
          }
        }
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
      connectNodes(n, getNeighbours(n)); 
    }
  }
    
    public void markVisit(Node n) {
      team.visited[n.col][n.row] = true;
      grid.changeColorOfNode(n, color(34, 255, 0));
    }
    
    public void markSeen(Node n) {
      grid.changeColorOfNode(n, color(255, 204, 0));
    }
    
    public void initialize() {
    }
    
    //Random walk.
    public void patrol() {
      currentNode = grid.getNearestNode(getRealPosition());
      ArrayList<Node> neighbouringNodes = getNeighbours(currentNode);
      ArrayList<Node> unvisitedNeighbours = new ArrayList<>();
      
      connectNodes(currentNode, neighbouringNodes);
      
      for (Node n : neighbouringNodes) {
        if (lookForTanks(n)) {
          return;
        }
        
        if (!team.visited[n.col][n.row]) {
          unvisitedNeighbours.add(n);
        }
      }
      
      println("Neighbours: " + neighbouringNodes.size());
      println("Unvisited: " + unvisitedNeighbours.size());
      
      if (unvisitedNeighbours.size() == 0) {
        Node node = neighbouringNodes.get((int) random(neighbouringNodes.size()));
        moveTo(node.position);
      }
      else {
        Node node = unvisitedNeighbours.get((int) random(unvisitedNeighbours.size()));
        moveTo(node.position);
      }
    }
    
    public void connectNodes(Node current, ArrayList<Node> nodes) {
      if (team.graph.containsKey(current)) {
        for(Node n : nodes) {
          if(!contains(team.graph.get(current), n)) {
            team.graph.get(current).add(n);
          }
        }
      }
      else {
        team.graph.put(current, nodes);
      }
      
      for (Node node : nodes) {
        if (team.graph.containsKey(node)) {
          if(!contains(team.graph.get(node), current)) {
            team.graph.get(node).add(current);
          }
        }
      else {
          ArrayList<Node> tmp = new ArrayList<>();
          tmp.add(current);
          team.graph.put(node, tmp);
        }
      }
      
    }
    
    boolean contains(ArrayList<Node> list, Node target) {
      for(Node n : list) {
        if(n == target) {
          return true;
        }
      }
      return false;
    }
    
    public ArrayList<Node> getNeighbours(Node current) {
      ArrayList<Node> neighbouringNodes = new ArrayList<>();
      
      for (int i = 0; i < col_directions.length; i++) {
        int newCol = current.col + col_directions[i];
        int newRow = current.row + row_directions[i];
        
        //Skip out of bounds.
        if (newRow < 0 || newCol < 0 || newRow >= grid.rows || newCol >= grid.cols) {
           continue;
        }
        
        Node n = grid.nodes[newCol][newRow];

        if(!team.visited[newCol][newRow]) {
          markSeen(n);
        }
        
        neighbouringNodes.add(n);
      }
      
      markVisit(current);
      return neighbouringNodes;
    }
    
    public boolean lookForTanks(Node n) {
      if (n.content() instanceof Tank) {
          Tank other = (Tank) n.content();
          
          if (other.team.id != this.team.id) {
            println("Found enemy tank, stoping search.");
            team.notifyTeam();
          }
        }
        
        return !searching;
    }
    
    public void findHome() {
      println(id + ": findHome");
      searching = false;
      homeBound = true;
      findShortestPathHome();
    }
   
    
    //Söker igenom instansens internalGraph (graf över kända noder) med hjälp av breadth-first search för att hitta en väg från tankens nuvarande position till en nod i hembasen. 
    public void findShortestPathHome() {
      Node start = grid.getNearestNode(getRealPosition()); 
      LinkedList<Node> visited = new LinkedList<>(); //här lagras alla noder som algoritmen besöker
      
      //Om startpunkten är samma som slutpunkten, avsluta
      if (start.equals(homeNode)) {
        visited.add(start);
        pathHome = visited;
        return;
      }
      
      //FIFO queue används, i enlighet med Russell och Norvigs förslag
      Queue<Node> queue = new LinkedList<>();
      queue.add(start);
      
      /*Så länge kön inte är tom, poll() första elementet i kön.
        Om elementet är en hemnod, hemvägen är hittad.
        Annars, gå igenom alla dess grannar och kolla om de är hemnoder. Om ja, hemvägen är hittad.*/
      while(!queue.isEmpty()) {
        Node current = queue.poll();
        if(current == homeNode ||isHomeNode(current)) {
          visited.add(current);
          queue.clear();
          break;
        }
        
        if (visited.contains(current)) {
          continue;
        }
        
        visited.add(current);
        for (Node n : team.graph.get(current)) {
          if (n == homeNode || isHomeNode(n)) {
            visited.add(n);
            queue.clear();
            println("FOund home");
            break;
          }
          queue.add(n);
        }
      }
      
      //Trimma ner vägen till kortaste vägen
      pathHome = trim(visited);
      println("Done with pathing");
      println("Queue size: " + queue.size());
      return;
    }
    
    public boolean isHomeNode(Node n) {
      return n.position.x > team.homebase_x && 
      n.position.x < team.homebase_x+team.homebase_width &&
      n.position.y > team.homebase_y &&
      n.position.y < team.homebase_y+team.homebase_height;
    }
    
    public LinkedList<Node> trim(LinkedList<Node> list) {
      for(int i = list.size() - 1; i > 0; i--) {
            if(i > 2 && nodeIsNotPartOfShortestPath(list.get(i), list.get(i - 1), list.get(i - 2)))  {
                list.set(i - 1, list.get(i));
                list.remove(i);
            }
        }
        if (list.size() < 2) {
          list.clear();
        }
        for(Node n : list) {
          grid.changeColorOfNode(n, color(0, 34, 255));
          print("(" + n.position.x + ", " + n.position.y + ")");
        }
        println();
        grid.changeColorOfNode(list.getLast(), color(255,17,0));
        println("path length: " + list.size());
        return list;
    }
    
    private boolean nodeIsNotPartOfShortestPath(Node currentNode, Node nextNode, Node nextNextNode) {
        return !team.graph.get(currentNode).contains(nextNode) || team.graph.get(nextNextNode).contains(currentNode);
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
          patrol();
        }
        else if (this.idle_state && homeBound) {
          moveAlongHome();
        }
      }
    }
  }
