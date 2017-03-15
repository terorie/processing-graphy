static final String JSON_NODES     = "Nodes";
static final String JSON_NODE_ID   = "ID";
static final String JSON_NODE_POSX = "PosX";
static final String JSON_NODE_POSY = "PosY";
static final String JSON_NODE_TAG  = "Tag";
static final String JSON_CONNS     = "Connections";
static final String JSON_CONN_ID   = "ID";
static final String JSON_CONN_IN   = "InNode";
static final String JSON_CONN_OUT  = "OutNode";
static final String JSON_CONN_BIDIR= "BiDir";
static final String JSON_CONN_VALUE= "Weight";
static final String FILE_JSON      = "data.json";

void load() throws IllegalArgumentException, IOException {
  // Initialize
  conns.clear();
  nodes.clear();
  selection = null;
  rightClick = null;
  neuClick = true;
  lastAdded = null;
  dik = null;
  start = null;
  stop = null;
  // Read
  JSONObject state = loadJSONObject(FILE_JSON);
  convertFromJSON(state);
}

void save() throws IOException {
  // Write
  JSONObject state = convertToJSON();
  saveJSONObject(state, FILE_JSON);
}

JSONObject convertToJSON() {
  JSONObject root = new JSONObject();

  JSONArray jsonNodes = new JSONArray();
  int nodeID = 0;
  for (Node n : nodes) {
    JSONObject jsonNode = new JSONObject();
    jsonNode.setLong(JSON_NODE_ID, n.id);
    jsonNode.setFloat(JSON_NODE_POSX, n.cx);
    jsonNode.setFloat(JSON_NODE_POSY, n.cy);
    if (n.tag != null)
      jsonNode.setString(JSON_NODE_TAG, n.tag);
    jsonNodes.setJSONObject(nodeID++, jsonNode);
  }
  root.setJSONArray(JSON_NODES, jsonNodes);

  JSONArray jsonConns = new JSONArray();
  int connID = 0;
  for (Connection c : conns) {
    JSONObject jsonConn = new JSONObject();
    jsonConn.setLong(JSON_CONN_ID, connID);
    jsonConn.setLong(JSON_CONN_IN, c.in.id);
    jsonConn.setLong(JSON_CONN_OUT, c.out.id);
    jsonConn.setInt(JSON_CONN_VALUE, c.weight);
    jsonConn.setBoolean(JSON_CONN_BIDIR, c.bidir);
    jsonConns.setJSONObject(connID, jsonConn);
    connID++;
  }
  root.setJSONArray(JSON_CONNS, jsonConns);

  return root;
}

void convertFromJSON(JSONObject root) throws IllegalArgumentException {
  JSONArray jsonNodes = root.getJSONArray(JSON_NODES);
  HashMap<Long, Node> nodeCache = new HashMap<Long, Node>();
  if(jsonNodes == null)
    throw new IllegalArgumentException("Nodes missing");
  for(int i = 0; i < jsonNodes.size(); ++i) {
    JSONObject jsonNode = jsonNodes.getJSONObject(i);
    if(jsonNode == null)
      throw new IllegalArgumentException("Node missing");
      
    long nodeID = jsonNode.getLong(JSON_NODE_ID, -1);
    if(nodeID == -1) 
      throw new IllegalArgumentException("Invalid node entry");
      
    float nodePosX = jsonNode.getFloat(JSON_NODE_POSX, -1.0f);
    if(nodePosX == -1.0f)
      throw new IllegalArgumentException("Invalid node entry");
      
    float nodePosY = jsonNode.getFloat(JSON_NODE_POSY, -1.0f);
    if(nodePosY == -1.0f)
      throw new IllegalArgumentException("Invalid node entry");
      
    String nodeTag = jsonNode.getString(JSON_NODE_TAG);
    
    Node node = new Node(i, nodePosX, nodePosY, Color.DEFAULT);
    node.tag = nodeTag;
    nodes.add(node);
    nodeCache.put(nodeID, node);
  }
  // Write node index to main
  id = jsonNodes.size();
  
  JSONArray jsonConns = root.getJSONArray(JSON_CONNS);
  if(jsonConns == null)
    throw new IllegalArgumentException("Conns missing");
  for(int i = 0; i < jsonConns.size(); ++i) {
    JSONObject jsonConn = jsonConns.getJSONObject(i);
    if(jsonConn == null)
      throw new IllegalArgumentException("Node missing");
    
    long nodeInID = jsonConn.getLong(JSON_CONN_IN);
    Node in = nodeCache.get(nodeInID);
    if(in == null)
      throw new IllegalArgumentException("Invalid connection entry");
    
    long nodeOutID = jsonConn.getLong(JSON_CONN_OUT);
    Node out = nodeCache.get(nodeOutID);
    if(out == null)
      throw new IllegalArgumentException("Invalid connection entry");
    
    int connWeight = jsonConn.getInt(JSON_CONN_VALUE, -1);
    if(connWeight == -1)
      throw new IllegalArgumentException("Invalid connection entry");
    
    boolean connBidir = jsonConn.getBoolean(JSON_CONN_BIDIR);
    
    Connection conn = new Connection(in, out, connWeight, connBidir, Color.DEFAULT);
    conns.add(conn);
  }
}