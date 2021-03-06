class Connection {
  public final Node in;
  public final Node out;
  public final int weight;
  public final boolean bidir;
  public Color col;

  Connection(Node in, Node out, int w, boolean bidir, Color c) {
    this.in = in;
    this.out = out;
    this.weight = w;
    this.col = c;
    this.bidir = bidir;
  }

  void draw() {
    strokeWeight(2);
    switch(col) {
    case DEFAULT:
      stroke(191, 191, 192); 
      break;
    case RED:
      stroke(255, 0, 0); 
      break;
    case GREEN:
      stroke(0, 255, 0); 
      break;
    case YELLOW:
      stroke(255, 255, 0); 
      break;
    }

    // Draw line
    line(in.cx, in.cy, out.cx, out.cy); 

    // Draw arrow
    if(!bidir) {
      pushMatrix();
      translate(out.cx, out.cy);
      rotate(atan2(out.cy-in.cy, out.cx-in.cx));
      noFill();
      triangle(-11, 0, -19, 5, -19, -5);
      popMatrix();
    }
  }

  // SAU WICHTIG (ArrayList.contains)
  boolean equals(Object another) {
    if (this == another) return true;
    if (another instanceof Connection) {
      Connection c = (Connection) another;
      
      return 
        (
        this.bidir == true
        &&
        (this.in == c.in && this.out == c.out) 
        ||
        (this.in == c.out && this.out == c.in)
        )
        ||
        (
        this.bidir == false
        &&
        (this.in == c.in && this.out == c.out) 
        );
    } else return false;
  }
  int hashCode() {
    return 38348 * (int)(in.hashCode() + out.hashCode());
  }
}