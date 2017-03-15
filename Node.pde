public class Node {
  
  // Coordinates
  public float cx, cy;
  public Color col;
  private int id;
  public String tag;
  
  public Node(int id, float x, float y, Color col) {
    cx = x;
    cy = y;
    this.col = col;
    this.id = id;
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
    
    if(tag != null) drawTag();
  }
  
  // Zeichnen, falls die Maus über dem Knoten liegt
  public void drawHighlight() {
    noStroke();
    fill(127, 127, 255);
    ellipse(cx, cy, 25, 25);
    
    if(tag != null) drawTag();
  }
  
  // Zeichnen, falls aktiviert
  public void drawActivated() {
    noStroke();
    fill(255, 0, 255);
    ellipse(cx, cy, 25, 25);
    
    if(tag != null) drawTag();
  }
  
  // Zeichnen, falls Spezialll
  public void drawSpecial() {
    noStroke();
    fill(255, 255, 0);
    ellipse(cx, cy, 25, 25);
    
    if(tag != null) drawTag();
  }
  
  public void drawTag() {
    // background
    noStroke();
    fill(0, 0, 0, 127);
    rect(cx+20, cy-10, 5+5*(tag.length()), 10);
    
    // text
    fill(255);
    textSize(10);
    text(tag, cx+25, cy);
  }
  
  public void drawSpecialTag(int tag) {
    // background
    noStroke();
    fill(0, 0, 0, 127);
    rect(cx+20, cy+5, 10+(5*(floor(log(tag)))), 10);
    
    // text
    fill(255, 255, 0);
    textSize(10);
    text(tag, cx+25, cy+15);
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