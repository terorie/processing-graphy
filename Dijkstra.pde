import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.List;
import java.util.LinkedList;
import java.util.Collections;

public class Dijkstra implements Runnable {

  Settings settings;
  Set<Node> nodes;
  Set<Connection> conns;
  Set<Node> settledNodes;
  Set<Node> unsettledNodes;
  Node start, stop;
  Map<Node, Node> vorgaenger;
  Map<Node, Integer> distance;
  Node highlight = null;

  public Dijkstra(Set<Node> nodes, Set<Connection> conns, Settings settings, Node start, Node stop) {
    this.settings = settings;
    this.nodes = nodes;
    this.conns = conns;
    this.start = start;
    this.stop = stop;
  }

  @Override
  public void run() {
    if (settings.isCalculating)
      return;
    settings.isCalculating = true;
    settledNodes = new HashSet<Node>();
    unsettledNodes = new HashSet<Node>();
    distance = new HashMap<Node, Integer>();
    vorgaenger = new HashMap<Node, Node>();
    distance.put(start, 0);
    unsettledNodes.add(start);
    while(unsettledNodes.size() > 0) {
      Node node = getMinimum(unsettledNodes);
      
      if(highlight != null)
        highlight.col = Color.DEFAULT;
        
      settledNodes.add(node);
      
      highlight = node;
      highlight.col = Color.RED;
      
      unsettledNodes.remove(node);
      findMinimalDistances(node);
      
      if(settings.calculationDelay > 0) {
        try {
          Thread.sleep(100*settings.calculationDelay);
        } catch(InterruptedException ignored) {}
      }
    }
    work();
    settings.isCalculating = false;
  }

  private void work() {
    settings.path = new LinkedList<Node>();
    Node step = stop;
    if (vorgaenger.get(step) == null) {
      return;
    }

    settings.path.add(step);
    while (vorgaenger.get(step) != null) {
      step = vorgaenger.get(step);
      settings.path.add(step);
    }

    Collections.reverse(settings.path);
  }

  private Node getMinimum(Set<Node> nodes) {
    Node minimum = null;
    for (Node node : nodes) {
      if (minimum == null) {
        minimum = node;
      } else {
        if (getShortestDistance(node) < getShortestDistance(minimum)) {
          minimum = node;
        }
      }
    }
    return minimum;
  }

  private int getShortestDistance(Node destination) {
    Integer d = distance.get(destination);
    if (d == null) {
      return Integer.MAX_VALUE;
    } else {
      return d;
    }
  }

  private int getDistance(Node node, Node target) {
    for (Connection conn : conns) {
      if (conn.in == node && conn.out == target) {
        return conn.weight;
      }
    }
    throw new RuntimeException("rip in piss forever miss");
  }

  private List<Node> getNeighbors(Node node) {
    List<Node> neighbors = new ArrayList<Node>();
    for (Connection conn : conns) {
      if (conn.in == node && !settledNodes.contains(conn.out)) {
        neighbors.add(conn.out);
      }
    }
    return neighbors;
  }

  private void findMinimalDistances(Node node) {
    List<Node> adjacentNodes = getNeighbors(node);
    for (Node target : adjacentNodes) {
      int lelWat = getShortestDistance(node) + getDistance(node, target);
      if (getShortestDistance(target) > lelWat) {
        distance.put(target, lelWat);
        vorgaenger.put(target, node);
        //target.col = Color.YELLOW;
        unsettledNodes.add(target);
      }
    }
  }
}