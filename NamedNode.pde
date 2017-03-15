class NamedNode extends Node {
  
  public final String name;
  
  NamedNode(int id, int x, int y, String name) {
    super(id, x, y, Color.DEFAULT);
    this.name = name;
    print("Knoten „" + name + "“ hinzugefügt\n");
  }
 
  // Normales Zeichnen
  public void draw() {
    strokeWeight(0);
    fill(255);
    ellipse(cx, cy, 20, 20);
    fill(255, 0, 0);
    text(name, cx, cy);
  }
  
  // Zeichnen, falls die Maus über dem Knoten liegt
  public void drawHighlight() {
    strokeWeight(0);
    fill(127, 127, 255);
    ellipse(cx, cy, 25, 25);
    fill(255, 0, 0);
    text(name, cx, cy);
  }
  
  // Zeichnen, falls aktiviert
  public void drawActivated() {
    strokeWeight(0);
    fill(255, 0, 255);
    ellipse(cx, cy, 25, 25);
    fill(255, 0, 0);
    text(name, cx, cy);
  }
  
}