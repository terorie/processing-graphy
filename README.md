# processing-graphy

Processing graph sketch

Root file is GRAPHYEAAA.pde

Usage:

 - Spacebar: Create new node at mouse pointer
 - Click mouse on node and drag to another: Connect two nodes
 - Backspace: Delete node at mouse pointer
 - Key S: Print stats to console
 - Key G: Enable gravity (attract nodes to middle)
 - Key F: Freeze nodes (stop movement)
 - Key Y: Connect all nodes (due to a bug in either FX2D/P2D, Z on German keyboard)
 - Key V: Vibrate nodes (Small random movements)
 - Key K: Shake nodes (Big random movements)
 - Key P: Find shortest path between nodes
 
TODOs:

 - Bidirectional edges
 - Code cleanup
 - Dijkstra walkthrough
 - Abstraction thing
 - Fix graphics
 - Fix color handling (and duplicate node drawing related)
 - Show orientation on directional arrow
 - Nicer toolbar window
 - Delete single connections
 - Scaling forces (More nodes -> more force)
 - Performance (but who cares)
