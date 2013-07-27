class UFO
{
  Body body;
  PImage img;
  float scale;
  int direction = 1;
  float speed = 15.0f;
  
  ChainShape chain = new ChainShape();
  //vertices of UFO's physic shape
  Vec2[] vertices = new Vec2[]
  {
    new Vec2(-150, 11),
    new Vec2(0, 75),
    new Vec2(150, 11),
    new Vec2(69, -32),
    new Vec2(44, -73),
    new Vec2(-43, -73),
    new Vec2(-66, -32)
  };

  // Constructor
  UFO(PImage ufoImg, float scaleAmount) 
  {
    img = ufoImg;
    scale = scaleAmount;
    //scaling vertices and converting to world coordinates
    for(int i = 0; i < vertices.length; ++i)
    {
      vertices[i] = vertices[i].mul(scaleAmount);
      vertices[i] = new Vec2(vertices[i].x + width / 2, vertices[i].y + height / 2);
      vertices[i] = box2d.coordPixelsToWorld(vertices[i]);
    }
    makeBody();
  }
  
  //draws UFO
  void display() 
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    MassData data = new MassData();
    body.getMassData(data);
    if(pos.x < 0f)
      inverseDirection();

    imageMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    image(img, 0, 0, img.width * scale, img.height * scale);
    popMatrix();
  }
  
  //inverses UFO movement direction
  void inverseDirection()
  {
    direction = direction == 1 ? -1 : 1;
  }
  
  //moves UFO by setting it's linear velocity
  void move(float time)
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    //prevents UFO from getting behind left/right screen borders
    if(pos.x < img.width * 0.5 || pos.x > width - img.width * 0.5)
      inverseDirection();
    body.setLinearVelocity(new Vec2(time * speed * direction * 100.0f, 0f));
  }
  
  //resets ufo position to center screen
  void resetPosition()
  {
    body.setTransform(box2d.coordPixelsToWorld(
      new Vec2(width / 2, height -50 - img.height / 2)), 0.0);
  }
  
  //constructs ufo physic body
  void makeBody() 
  {
    Vec2 center = new Vec2(width / 2, height -50 - img.height / 2);
    
    chain.createLoop(vertices, vertices.length);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
    bd.position = box2d.coordPixelsToWorld(center);
    //adds info about body type (used when processing contacts)
    bd.userData = "ufo";
    body = box2d.createBody(bd);
    body.createFixture(chain, 1);
  }
}


