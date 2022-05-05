import java.util.HashSet;
/* En CommunicationHandler sköter uppdateringen av agenternas respektive Teams kunskapsbaser 
   och ser till att varje agents interna kunskapsbas är identisk med kunskapsbasen i det Team de tillhör, om connectionUp = true */
class CommunicationHandler {
  private boolean connectionUp;
  private boolean teamIsUpToDate;
  private Team team;
  
  /* Skapar en CommunicationHandler tillhörande det angivna teamet */
  public CommunicationHandler(Team team) {
    this.team = team;
    connectionUp = true;
    teamIsUpToDate = true;
  }
  
  /* Varje gång draw() kallas körs även denna metod. Om connectionUp, kolla om team-kunskapsbasen behöver uppdateras.
     Uppdatera sedan varje agents interna kunskapsbas med team-kunskapsbasen.
     Om !connectionUp, gör ingenting. */
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
  
  /* Slår på kommunikationen mellan agenter.*/
  public void turnOn() {
    connectionUp = true;
  }
  
  /* Stänger av kommunikationen mellan agenter, samt flaggar att team-kunskapsbasen behöver uppdateras när kommunikation slås på igen.*/
  public void turnOff() {
    connectionUp = false;
    teamIsUpToDate = false;
  }
  
  /* Returnerar den nuvarande statusen för CommunicationHandler */
  public boolean connectionIsUp() {
    return connectionUp;
  }
  
  /* Uppdaterar en agents kunskapsbas med en kopia av team-kunskapsbasen */
  private void updateKnowledge(AgentTank agent) {
    agent.internalKnowledge.graph = new HashMap<>(team.knowledgeBase.graph);
    agent.internalKnowledge.visited = (boolean[][]) team.knowledgeBase.visited.clone();
    agent.internalKnowledge.seen = (boolean[][]) team.knowledgeBase.seen.clone();
  }
 
 /* Uppdaterar team-kunskapsbasen med de ändringar som skett i respektive agents interna kunskapsbas*/
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
