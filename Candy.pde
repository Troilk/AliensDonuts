class Candy
{
  Body body;
  float rad;
  PImage img;
  boolean removed = false;

  // Constructor
  Candy(PImage candyImg) 
  {
    img = candyImg;
    rad = random(8, 16);
    makeBody();
  }

  void killBody() 
  {
    box2d.destroyBody(body);
  }
  
  //removes candy from physics world and adds to score or removes health
  boolean done() 
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if(removed)
    {
      killBody();
      score += rad;
      return true;
    }
    if (pos.y > height + rad) 
    {
      killBody();
      --lifes;
      return true;
    }
    return false;
  }
  
  //draws donut
  void display() 
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    imageMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    image(img, 0, 0, rad * 2, rad * 2);
    popMatrix();
  }
  
  //contructs donut physics body
  void makeBody() 
  {
    Vec2 center = new Vec2(random(rad, width - rad), -rad);
    
    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(rad);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = circle;
    //Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    //Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.userData = this;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
  }
}


