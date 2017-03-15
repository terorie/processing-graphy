public class Node {
  
  // Coordinates
  public float cx, cy;
  public Color col;
  private int id;
  
  public Node(int id, int x, int y, Color col) {
    cx = x;
    cy = y;
    this.col = col;
    this.id = id;
    print("Knoten hinzugefügt\n");
  }
 
  // convienience is business
  public void move(double x, double y) {
    if(cx+x>620 || cx+x<20 || cy+y>460 || cy+y<20) {
      return;
    } // Nich aus bildschirm raus
    cx += x;
    cy += y;
  }
 
  // Gibt zurück ob die Maus auf diesem Knoten liegt
  public boolean isMouseOn(int x, int y) {
    return x<cx+10 && x>cx-10 && y<cy+10 && y>cy-10;
  }
 
  // Normales Zeichnen
  public void draw() {
    noStroke();
    switch(col) {
      case DEFAULT:
        fill(255); break;
      case RED:
        fill(255, 0, 0); break;
      case GREEN:
        fill(0, 255, 0); break;
      case YELLOW:
        fill(255, 255, 0); break;
    }
    
    ellipse(cx, cy, 20, 20);
  }
  
  // Zeichnen, falls die Maus über dem Knoten liegt
  public void drawHighlight() {
    noStroke();
    fill(127, 127, 255);
    ellipse(cx, cy, 25, 25);
  }
  
  // Zeichnen, falls aktiviert
  public void drawActivated() {
    noStroke();
    fill(255, 0, 255);
    ellipse(cx, cy, 25, 25);
  }
  
  // Zeichnen, falls Spezialll
  public void drawSpecial() {
    noStroke();
    fill(255, 255, 0);
    ellipse(cx, cy, 25, 25);
  }
  
  // SparseArray as HashMap…
  public int hashCode() {
    return 2839429 * id;
  }
  
  // SparseArray as HashMap…
  public boolean equals(Object another) {
    if(another instanceof Node) {
      Node n = (Node) another;
      return n.id == id;
    }
    return false;
  }
}