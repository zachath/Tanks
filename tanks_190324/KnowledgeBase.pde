import java.util.HashSet;
class KnowledgeBase {
  HashMap<Node, HashSet<Node>> graph = new HashMap<>();
  boolean[][] visited = new boolean[grid.cols][grid.rows];
  boolean[][] seen = new boolean[grid.cols][grid.rows];
  
  Team team;
  
  public KnowledgeBase(Team team) {
    this.team = team;
    
    connectHomeBaseNodes();
  }
  
  //Lägg till alla hembasnoder till "minnet"
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
  
  public boolean isHomeNode(Node n) {
      return n.position.x > team.homebase_x && 
      n.position.x < team.homebase_x+team.homebase_width &&
      n.position.y > team.homebase_y &&
      n.position.y < team.homebase_y+team.homebase_height;
    }
    
  public void markVisit(Node n) {
      visited[n.col][n.row] = true;
      grid.changeColorOfNode(n, color(34, 255, 0));
    }
    
    public void markSeen(Node n) {
      seen[n.col][n.row] = true;
      grid.changeColorOfNode(n, color(255, 204, 0));
    }
    
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
    
    boolean isConnected(Node source, Node target) {
      if(graph.get(source).contains(target)) {
        return true;
      }
      
      return false;
      /*for(Node n : graph.get(source)) {
        if(n == target) {
          return true;
        }
      }
      return false;*/
    }
    
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
    
    public void merge(KnowledgeBase source) {
      //update each key with the values from source
      for(Node n : source.graph.keySet()) {
        connectNodes(n, source.graph.get(n));
      }
      
      //TO-DO: fixa visited och seen
    }
}
