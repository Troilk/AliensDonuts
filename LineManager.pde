class LineManager
{
  Body body;
  Fixture[] chain;
  Vec2[] segments;
  int currentSegment;
  float lineWeight;
  color lineColor;

  // Constructor
  LineManager(int maxSegments, float lWeight, color lColor) 
  {
    lineWeight = lWeight;
    lineColor = lColor;
    segments = new Vec2[maxSegments];
    chain = new Fixture[maxSegments];
    for(int i = 0; i < maxSegments; ++i)
      segments[i] = new Vec2(0, 0);
    currentSegment = 0;
    makeBody();
  }
  
  //draws line to screen
  void display() 
  {
    strokeWeight(lineWeight);
    stroke(lineColor);
    noFill();
    beginShape();
    int i = currentSegment - 1;
    Vec2 temp;
    for(;i >= 0; --i) 
    {
      temp = box2d.coordWorldToPixels(segments[i]);
      vertex(temp.x, temp.y);
    }
    for(i = segments.length - 1;i >= currentSegment; --i) 
    {
      temp = box2d.coordWorldToPixels(segments[i]);
      vertex(temp.x, temp.y);
    }
    endShape();
  }
  
  //adds segment to chain, removing old one
  void addSegment(int x1, int y1, int x2, int y2)
  {
    Vec2 newVertex = new Vec2(x2, y2);
    Vec2 oldVertex = new Vec2(x1, y1);
    newVertex = box2d.coordPixelsToWorld(newVertex);
    oldVertex = box2d.coordPixelsToWorld(oldVertex);
    segments[currentSegment] = newVertex;
    EdgeShape shape = new EdgeShape();
    shape.set(newVertex, oldVertex);
    body.destroyFixture(chain[currentSegment]);
    chain[currentSegment] = body.createFixture(shape, 1);
    
    currentSegment = (currentSegment + 1) % segments.length;
  }
  
  void makeBody()
  { 
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(width / 2, height / 2)));
    body = box2d.createBody(bd);
    
    for(int i = 0; i < chain.length; ++i)
    {
      EdgeShape shape = new EdgeShape();
      chain[i] = body.createFixture(shape, 1);
    }
  }
}


