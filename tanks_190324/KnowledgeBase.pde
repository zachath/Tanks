import java.util.HashSet;
/* Representerar en kunskapsbas i form av en graf av de noder som finns i Grid */
class KnowledgeBase {
  /* Varje nyckel representerar en nod i rutnätet, och värdet för varje nyckel är ett HashSet med de upptäckta noder som ligger 1 steg ifrån nyckelnoden */
  HashMap<Node, HashSet<Node>> graph = new HashMap<>();
  
  /* Håller reda på vilka noder som har besökts av en agent i teamet */
  boolean[][] visited = new boolean[grid.cols][grid.rows];
  
  /* Håller reda på vilka noder som har setts av en agent i teamet*/
  boolean[][] seen = new boolean[grid.cols][grid.rows];
  
  Team team;
  
  /* Skapar en KnowledgeBase som tillhör det angivna teamet */
  public KnowledgeBase(Team team) {
    this.team = team;
    
    connectHomeBaseNodes();
  }
  
  /* Lägger till alla noder som befinner sig innanför hembasen i grafen, samt deras närliggande noder. Dessa markeras som besökta, medan deras närliggande noder markeras som sedda. */
    void connectHomeBaseNodes() {
      for(Node[] nArr : grid.nodes) {
        for(Node n : nArr) {
          if(isHomeNode(n)) {
            markVisit(n);
            connectNodes(n, grid.getNeighbours(n));
          }
        }
      }
    }
  
  /* Returnerar true om noden befinner sig innanför hembasen, annars false */
  public boolean isHomeNode(Node n) {
      return n.position.x > team.homebase_x && 
      n.position.x < team.homebase_x+team.homebase_width &&
      n.position.y > team.homebase_y &&
      n.position.y < team.homebase_y+team.homebase_height;
    }
    
  /* Markerar noden som besökt i visited[][] och färglägger noden grön*/
  public void markVisit(Node n) {
      visited[n.col][n.row] = true;
      grid.changeColorOfNode(n, color(34, 255, 0));
    }
    
    /* Markerar noden som besökt i seen[][] och färglägger noden gul */
    public void markSeen(Node n) {
      seen[n.col][n.row] = true;
      grid.changeColorOfNode(n, color(255, 204, 0));
    }
    
    /* Skapar en relation mellan n1 och n2 i kunskapsbasen. */
    public void connectNodes(Node n1, Node n2) {
      if (graph.containsKey(n1)) {
        graph.get(n1).add(n2);
      }
      else {
        HashSet<Node> tmp = new HashSet();
        tmp.add(n2);
        graph.put(n1, tmp);
      }
    }
    
    /* Skapar en relation mellan current och noderna i nodes */
    public void connectNodes(Node current, ArrayList<Node> nodes) {
      if (graph.containsKey(current)) {
        graph.get(current).addAll(nodes);
      }
      else {
        graph.put(current, new HashSet<Node>(nodes));
      }
      
      for (Node node : nodes) {
        connectNodes(node, current);
      }
    }
    
    /* Skapar en relation mellan current och noderna i nodes */
    public void connectNodes(Node current, HashSet<Node> nodes) {
      if (graph.containsKey(current)) {
        graph.get(current).addAll(nodes);
      }
      else {
        graph.put(current, new HashSet<Node>(nodes));
      }
      
      for (Node node : nodes) {
        connectNodes(node, current);
      }
    }
    
    /* Returnerar true om n1 har en relation till n2 */
    boolean isConnected(Node n1, Node n2) {
      if(graph.get(n1).contains(n2)) {
        return true;
      }
      
      return false;
    }
    
    /* Hittar en väg från start till en nod i hembasen */
    public LinkedList<Node> findPathHome(Node start) {
      LinkedList<Node> visitedNodes = new LinkedList<>(); //här lagras alla noder som algoritmen besöker
      
      //Om startpunkten är samma som slutpunkten, avsluta
      if (isHomeNode(start)) {
        visitedNodes.add(start);
        return visitedNodes;
      }
      
      //FIFO queue används, i enlighet med Russell och Norvigs förslag
      Queue<Node> queue = new LinkedList<>();
      queue.add(start);
      
      /*Så länge kön inte är tom, poll() första elementet i kön.
        Om elementet är en hemnod, hemvägen är hittad.
        Annars, gå igenom alla dess grannar och kolla om de är hemnoder. Om ja, hemvägen är hittad.*/
      while(!queue.isEmpty()) {
        Node current = queue.poll();
        if(isHomeNode(current)) {
          visitedNodes.add(current);
          queue.clear();
          break;
        }
        
        if (visitedNodes.contains(current)) {
          continue;
        }
        
        visitedNodes.add(current);
        for (Node n : graph.get(current)) {
          if (isHomeNode(n)) {
            visitedNodes.add(n);
            queue.clear();
            println("Found home");
            break;
          }
          queue.add(n);
        }
      }
      
      //Trimma ner vägen till kortaste vägen
      visitedNodes = trim(visitedNodes);
      println("Done with pathing");
      println("Queue size: " + queue.size());
      return visitedNodes;
    }
    
    /* Trimma ner en väg till kortaste vägen */
    private LinkedList<Node> trim(LinkedList<Node> list) {
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
        return !graph.get(currentNode).contains(nextNode) || graph.get(nextNextNode).contains(currentNode);
    }
    
    /* Går igenom currents närliggande grannar och, om de inte har besökts förut, skapar relationer mellan de och current */
    public void checkNeighbours(Node current) {
      markVisit(current);
      ArrayList<Node> neighbours = grid.getNeighbours(current);
      for(Node n : neighbours) {
        if(!visited[n.col][n.row]) {
          markSeen(n);
          connectNodes(current, n);
          connectNodes(n, current);
        }
      }
    }
    
    /* Samma som checkNeighbours men skapad specifikt för användning med LOS() i AgentTank */
    public void LOSCheckNeighbours(Node current) {
      for (int i = 0; i < col_directions.length; i++) {
        int newCol = current.col + col_directions[i];
        int newRow = current.row + row_directions[i];
        
        //Skip out of bounds.
        if(grid.outOfBounds(newCol, newRow)) {
          continue;
        }
        
        Node n = grid.nodes[newCol][newRow];

        if (seen[n.col][n.row]) {
          connectNodes(current, n);
          connectNodes(n, current);
        }
      }
    }
    
    /* Uppdaterar den nuvarande kunskapsbasen med de relationer som finns i source */
    public void merge(KnowledgeBase source) {
      //update each key with the values from source
      for(Node n : source.graph.keySet()) {
        connectNodes(n, source.graph.get(n));
      }
      
      for (int i = 0; i < source.visited.length - 1; i++) {
        for (int j = 0; j < source.visited[0].length - 1; j++) {
          if (source.visited[i][j]) {
            markVisit(grid.nodes[i][j]);
          }
          
          if (source.seen[i][j] && !visited[i][j]) {
            markSeen(grid.nodes[i][j]);
          }
        }
      }
    }
}
