class Connection {
  public final Node in;
  public final Node out;
  public final int weight;
  public Color col;
  
  Connection(Node in, Node out, int w, Color c) {
    this.in = in;
    this.out = out;
    this.weight = w;
    this.col = c;
  }
  
  void draw() {
    strokeWeight(2);
    switch(col) {
      case DEFAULT:
        stroke(191, 191, 192); break;
      case RED:
        stroke(255, 0, 0); break;
      case GREEN:
        stroke(0, 255, 0); break;
      case YELLOW:
        stroke(255, 255, 0); break;
    }
    
    line(in.cx, in.cy, out.cx, out.cy); 
  }
  
  // SAU WICHTIG (ArrayList.contains)
  boolean equals(Object another) {
    if(this == another) return true;
    if (another instanceof Connection) {
       Connection c = (Connection) another;
       // Direction doesn't matter!
       return 
         (
           (this.in == c.in && this.out == c.out) 
             ||
           (this.in == c.out && this.out == c.in)
         );
    }
    else return false;
  }
  int hashCode() {
     return 38348 * (int)(in.hashCode() + out.hashCode());
  }
}