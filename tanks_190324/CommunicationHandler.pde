class CommunicationHandler {
  private boolean connectionUp;
  private boolean teamIsUpToDate;
  private Team team;
  
  public CommunicationHandler(Team team) {
    this.team = team;
    connectionUp = true;
    teamIsUpToDate = true;
  }
  
  public void update() {
    if(connectionUp) {
      if(!teamIsUpToDate) {
        //mergeKnowledge();
      }
      
      for (Tank t : team.tanks) {
        if (t instanceof AgentTank) {
          updateKnowledge((AgentTank) t);
        }
      }
    }
  }
  
  public void turnOn() {
    connectionUp = true;
  }
  
  public void turnOff() {
    connectionUp = false;
    teamIsUpToDate = false;
    
    for (Tank t : team.tanks) {
      if (t instanceof AgentTank) {
        AgentTank agent = (AgentTank) t;
        agent.communicationPossible = false;
      }
    }
  }
  
  public boolean connectionIsDown() {
    return connectionUp;
  }
  
  private void updateKnowledge(AgentTank agent) {
    agent.internalGraph.graph = new HashMap<Node, ArrayList<Node>>(team.graph.graph);
    agent.internalGraph.visited = (boolean[][]) team.graph.visited.clone();
    agent.internalGraph.seen = (boolean[][]) team.graph.seen.clone();
  }
 
  
}
