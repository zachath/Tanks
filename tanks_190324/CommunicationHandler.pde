import java.util.HashSet;
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
        mergeKnowledge();
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
  }
  
  public boolean connectionIsUp() {
    return connectionUp;
  }
  
  private void updateKnowledge(AgentTank agent) {
    agent.internalKnowledge.graph = new HashMap<>(team.knowledgeBase.graph);
    agent.internalKnowledge.visited = (boolean[][]) team.knowledgeBase.visited.clone();
    agent.internalKnowledge.seen = (boolean[][]) team.knowledgeBase.seen.clone();
  }
 
  private void mergeKnowledge() {
    println("merging...");
    for(Tank t : team.tanks) {
      if (t instanceof AgentTank) {
         AgentTank agent = (AgentTank) t;   
         team.knowledgeBase.merge(agent.internalKnowledge);
       }
    }
    teamIsUpToDate = true;
  }
}
