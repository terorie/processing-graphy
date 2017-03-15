/** Graph in Processing
 *
 * Physikalischer Graph damit die Knoten alle schön aussehen.
 * Anleitung:
 *  - Leertaste fügt neuen Knoten hinzu
 *  - Backspace löscht Knoten unter der Maus
 *  - Clicken und ziehen zum Verbinden
 *  - Taste G aktiviert Schwerkraft
 *  - Taste K mischt die Knoten
 *
 * @author terorie (Richie Patel)  <terorie@alphakevin.club> */

import java.util.Set;
import java.util.HashSet;
import java.util.Random;

// Knotenliste zum Zeichnen
Set<Node> nodes = new HashSet<Node>();
// Verbindungsliste zum Zeichnen
Set<Connection> conns = new HashSet<Connection>();
// ( ͡° ͜ʖ ͡°) ( ͡⊙ ͜ʖ ͡⊙) ( ͡◉ ͜ʖ ͡◉)
// Weichspüler (Werte von 90-420 empfohlen)
static final int smoothness = 300;
// List IDs (können nicht wiederverwendet werden)
int id = 0;
// Letzter hinzugefügter Knoten
Node lastAdded = null;

// Toolbar Fenster
Toolbar toolbar;

Color colorId = Color.DEFAULT;

// Code kompliziert machen damit niemand mehr durchblickt :^)
boolean gravity = false;
boolean spast = false; 
Random rand = new Random(); 
boolean vibr = false;
boolean freeze = false;

// Ablaufen
CalcMode calcMode = CalcMode.OFF;
enum CalcMode {
  OFF, SELECT_1, SELECT_2, ON
}
Node start = null;
Node stop = null;
Dijkstra dik = null;

// Maus klick
Node selection = null;
Node rightClick = null;
boolean neuClick = true;

int tick = Integer.MIN_VALUE;

// "Callbacks"
class Settings {
  int connectionWeight = 5;
  int calculationDelay = 5;
  // Mutex
  boolean isCalculating = false;
  LinkedList<Node> path = null;
}
Settings settings;

void setup() {
  size(640, 480, P2D);
  smooth();
  colorMode(RGB);

  settings = new Settings();
  toolbar = new Toolbar(settings);
}

// Wird 60 mal in der Sekunde aufgerufen
// also vorsicht
void draw() {
  tick++;

  noStroke();

  if (spast) {
    switch((tick / 4) % 3) {
    case 0: 
      background(255, 0, 0); 
      break;
    case 1: 
      background(0, 255, 0); 
      break;
    case 2: 
      background(0, 0, 255); 
      break;
    }
  } else {
    background(0);
  }

  // Alle Knoten zeichnen
  Node highlighted = null;
  for (Node n : nodes) {
    if (n.isMouseOn(mouseX, mouseY) && !settings.isCalculating)
      (highlighted = n).drawHighlight();
    else
      n.draw();
  }

  // Alle Verbindungen zeichnen
  for (Connection c : conns) {
    c.draw();
  }

  switch(calcMode) {
  case OFF:
    // Schauen, ob blob angeklickt wurde
    // Blob jetz angeklickt
    if (mousePressed && (mouseButton == LEFT) && neuClick) {
      if (highlighted != null) {
        neuClick = false;
        selection = highlighted;
        selection.drawActivated();
      }
    }
    // Blob schon vorher angeklickt
    else if (mousePressed && (mouseButton == LEFT) && !neuClick && selection != null) {
      selection.drawActivated();
      strokeWeight(2);
      stroke(0, 255, 0);
      line(selection.cx, selection.cy, mouseX, mouseY);
    }
    // Blob losgelassen
    else if (!mousePressed && !neuClick) {
      // Schauen ob blob über anderem losgelassen wurde
      // JETZ GEHTS LOSS BOI
      for (Node n : nodes) {
        if (n.isMouseOn(mouseX, mouseY) && n != selection && !settings.isCalculating) {
          // Verbindung geschafft
          connect(selection, n, settings.connectionWeight);
        }
      }

      selection = null;
      neuClick = true;
    }
    break;

  case SELECT_1:
    if (highlighted != null && !mousePressed) {
      if ((tick % 120) > 60)
        highlighted.drawSpecial();
    } else if (highlighted != null && mousePressed && mouseButton == LEFT) {
      highlighted.col = Color.YELLOW;
      start = highlighted;
      calcMode = CalcMode.SELECT_2;
    }
    break;

  case SELECT_2:
    if (highlighted == start) break;
    if (highlighted != null && !mousePressed) {
      if (tick % 120 > 60)
        highlighted.drawActivated();
    } else if (highlighted != null && mousePressed && mouseButton == LEFT) {
      highlighted.col = Color.YELLOW;
      stop = highlighted;
      calcMode = CalcMode.ON;
      startDijkstra();
    }
    break;

  case ON:
    start.col = Color.RED;
    stop.col = Color.GREEN;
    if(settings.path != null) {
      for(Node n : settings.path) {
        n.drawSpecial();
        start.draw();
        stop.draw();
      }
    }
    break;
  }
  
  // Anziehungskräfte
  if (!freeze)
    stepPos();
}

void startDijkstra() {
  dik = new Dijkstra(nodes, conns, settings, start, stop);
  new Thread(dik).start();
}

void connect(Node in, Node out, int weight) {
  // Schauen ob die Verbindung schon existiert
  Connection c = new Connection(in, out, weight, colorId);
  if (!conns.contains(c)) {
    conns.add(c);
    print("Verbindung hinzugefügt\n");
  }
}

// Falls Maus gedrückt wurde, neuen Knoten erstellen
// und Positionen für ungütig erklären
void keyPressed() {
  switch(key) {
  case ' ': // Space macht neuen Knoten
    // Falls der letzte auf der gleichen Position ist, verschieben
    if (lastAdded != null && lastAdded.cx == mouseX && lastAdded.cy == mouseY) {
      lastAdded.cx += 10;
      lastAdded.cy -= 10;
    }
    lastAdded = new Node(id++, mouseX, mouseY, colorId);
    nodes.add(lastAdded);
    return;
  case '\b': // Backspace löscht Knoten
    for (Node n : nodes) {
      if (n.isMouseOn(mouseX, mouseY)) {
        nodes.remove(n);
        print("Knoten entfernt\n");
        ArrayList<Connection> killList = new ArrayList();
        // Verbindungen werden erst auf eine hitliste gesetzt und werden dann entfernt,
        // weil das programm abstürzen würde wenn man mehrere Verbindungen gleichzeitig 
        // beim enumerieren entfernt
        for (Connection c : conns) {
          if (c.in == n || c.out == n) {
            killList.add(c);
          }
        }
        for (Connection c : killList) {
          conns.remove(c);
          print("Verbindung entfernt\n");
        }
        return;
      }
    }
    return;
  case 's': 
  case 'S': // Statistiken
    print(nodes.size() + " Knoten\n");
    print(conns.size() + " Verbindungen\n");
    return;
  case 'g': 
  case 'G':
    gravity = !gravity;
    return;
  case 'k': 
  case 'K':
    spast = !spast;
    return;
  case 'f': 
  case 'F':
    freeze = !freeze;
    return;
  case 'y': 
  case 'Y':
    if (!settings.isCalculating) {
      if (conns.size() > 0) {
        conns.clear();
      } else {
        for (Node ne : nodes) {
          for (Node nee : nodes) {
            if (ne != nee)
              connect(ne, nee, settings.connectionWeight);
          }
        }
      }
    }
    return;
  case 'v': 
  case 'V':
    vibr = !vibr;
    return;
  case 'p':
  case 'P':
    if (calcMode == CalcMode.OFF)
      calcMode = CalcMode.SELECT_1;
    else {
      calcMode = CalcMode.OFF;
      if (start != null)
        start.col = Color.DEFAULT;
      if (stop != null)
        stop.col = Color.DEFAULT;
      start = null;
      stop = null;
    }

  case '1': 
  case '!':
    colorId = Color.DEFAULT;
    return;
  case '2': 
  case '"':
    colorId = Color.RED;
    return;
  case '3': 
  case '§':
    colorId = Color.GREEN;
    return;
  }
}

// Anziehungskräfte wirken lassen :^)
// Algorithmus: https://github.com/gephi/gephi/wiki/Fruchterman-Reingold
void stepPos() {
  // Kräfte„konstante“, die sich der Fenstergröße und Knotenmenge anpasst
  double forceConstant = sqrt(640 * 480 / (smoothness *  max(1, nodes.size())));
  // Anziehungskraft
  double attraction = 230 * forceConstant;
  // Abstoßungskraft
  double repulsion = 420 * forceConstant;

  // ##### ABSTOSSUNGSKRÄFTE #####
  // Schreckliche Performance und Trigonometrie yey!
  for (Node ne : nodes) {
    for (Node nee : nodes) {
      if (ne == nee) continue; // Selbst überspringen
      float deltaX = ne.cx - nee.cx;
      float deltaY = ne.cy - nee.cy;
      // Satz des Pythagoras, aber minimal 0,000001!
      double deltaD = Math.max(0.000001D, sqrt(deltaX*deltaX + deltaY*deltaY));
      // PHYSIK YEA
      //double force = (repulsion*repulsion) / deltaD;
      double force = repulsion / (deltaD*deltaD);
      // Alle Kräfte wirken auf Knoten 1
      ne.move((deltaX / deltaD) * force, (deltaY / deltaD) * force);
    }
  }

  // ##### ANZIEHUNGSKRÄFTE #####
  for (Connection c : conns) {
    float deltaX = c.in.cx - c.out.cx;
    float deltaY = c.in.cy - c.out.cy;
    // wurzel(a^2+b^2)
    double deltaD = Math.max(0.000001D, sqrt(deltaX*deltaX + deltaY*deltaY));
    // physikkkkkk
    double force = (deltaD * deltaD) / (attraction * c.weight);

    double finalX = (deltaX / deltaD) * force;
    double finalY = (deltaY / deltaD) * force;

    // Entegegen gesetzte richtung also minus
    c.in.move(-finalX, -finalY);
    c.out.move(finalX, finalY);//FINALlY
  }

  // ##### SCHWERKRAFT #####
  if (gravity) {
    for (Node nee : nodes) {
      float deltaX = 320 - nee.cx;
      float deltaY = 240 - nee.cy;
      // Satz des Pythagoras, aber minimal 0,000001!
      double deltaD = Math.max(0.000001D, sqrt(deltaX*deltaX + deltaY*deltaY));
      // PHYSIK YEA
      double force = (deltaD * deltaD) / (attraction * (nodes.size() / 2));
      // Alle Kräfte wirken auf Knoten 1
      nee.move((deltaX / deltaD) * force, (deltaY / deltaD) * force);
    }
  }

  // ##### SPAZZ OUT #####
  if (spast) {
    for (Node nee : nodes) {
      float deltaX = rand.nextInt(640) - nee.cx;
      float deltaY = rand.nextInt(480) - nee.cy;
      // Satz des Pythagoras, aber minimal 0,000001!
      double deltaD = Math.max(0.000001D, sqrt(deltaX*deltaX + deltaY*deltaY));
      // PHYSIK YEA
      double force = (deltaD * deltaD) / (attraction * 0.5);
      // Alle Kräfte wirken auf Knoten 1
      nee.move((deltaX / deltaD) * force, (deltaY / deltaD) * force);
    }
  }

  // ### bibrate ###
  if (vibr) {
    for (Node nee : nodes) {
      nee.move(random(5.0) - 2.5, random(5.0) - 2.5);
    }
  }
}