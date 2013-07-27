//http://lharboe.deviantart.com/art/Donuts-93179329
//http://www.freesound.org/people/silverduck/sounds/159724/
//http://www.clker.com/clipart-25108.html

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Maxim maxim;
AudioPlayer player;

color SunColor;
int clockwise = 1;
float sunRotation = 0.0f;
float sunWait = 0.0f;

color GrassColor;
PGraphics DrawingPic;
PGraphics SunPic;
PGraphics GrassPic;
PImage[] CandyTexs;
PBox2D box2d;
ArrayList<Candy> Candies;
UFO ufo;

int score = 0;
int highscore = 0;
int lifes = 20;

LineManager lineManager;

boolean displayMenu = true;
Button btnStart;

void setup()
{
  size(640, 960);
  smooth();
  GrassColor = color(20, 200, 10);
  SunColor = color(200, 200, 0);
  
  maxim = new Maxim(this);
  player = maxim.loadFile("music1.wav");
  player.setLooping(true);
  player.setAnalysing(true);
  //player.play();
  
  drawGrass();
  drawSun();
  DrawingPic = createGraphics(width, height);
  DrawingPic.beginDraw();
  DrawingPic.endDraw();
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -1);
  box2d.listenForCollisions();

  Candies = new ArrayList<Candy>();
  //loading candies
  CandyTexs = new PImage[6];
  for(int i = 0; i < CandyTexs.length; ++i)
    CandyTexs[i] = loadImage("candy" + i + ".png");
    
  ufo = new UFO(loadImage("ufo.png"), 0.6f);
    
  lineManager = new LineManager(32, 3.0, color(0, 0, 0));
  
  btnStart = new Button(width / 2, height - 200, 400, 80, loadImage("button.png"), "Start game", 0.3);
}

void drawMenu()
{
  fill(0, 150);
  rect(0, 0, width, height);
  textSize(42);
  textAlign(CENTER);
  fill(100, 227, 255);
  text("High score : " + highscore, width * 0.5, 200);
  textSize(32);
  text("Draw line wich will make donuts roll\ninto the alien spaceship!", width * 0.5, 500);
  btnStart.draw();
}

void drawGrass()
{
  GrassPic = createGraphics(width, height);
  GrassPic.beginDraw();
  GrassPic.pushMatrix();
  GrassPic.fill(GrassColor);
  GrassPic.stroke(0);
  GrassPic.strokeWeight(3);
  GrassPic.rotate(radians(-20));
  GrassPic.ellipse(width - 500, height - 70, 700, 330);
  GrassPic.rotate(radians(30));
  GrassPic.ellipse(100, height - 180, 450, 160);
  GrassPic.rotate(radians(-10));
  GrassPic.ellipse(width * 0.618, height - 20, width * 2, 300);
  GrassPic.popMatrix();
  GrassPic.endDraw();
}

void drawSun()
{
  int sunWidth = 480;
  SunPic = createGraphics(sunWidth, sunWidth);
  SunPic.beginDraw();
  SunPic.fill(SunColor);
  SunPic.noStroke();
  SunPic.ellipse(sunWidth / 2, sunWidth / 2, 240, 240);
  float angle = TWO_PI / 12;
  for(int i = 0; i < 12; ++i)
  {
    SunPic.pushMatrix();
    SunPic.translate(sunWidth / 2, sunWidth / 2);
    SunPic.rotate(i * angle);
    SunPic.triangle(0, -50, 0, 50, 240, 0);
    SunPic.popMatrix();
  }
  SunPic.endDraw();
}

void finishGame()
{
  if(score > highscore)
    highscore = score;
  score = 0;
  lifes = 20;
  for (int i = Candies.size()-1; i >= 0; i--) 
  {
    Candies.get(i).killBody();
    Candies.remove(i);
  }
  ufo.resetPosition();
  player.stop();
  displayMenu = true;
}

void update()
{
  if(displayMenu)
  {
    btnStart.update(1.0 / 60);
    return;
  }
  
  box2d.step();
  
  if (random(1) < 0.01) 
  {
    Candy p = new Candy(CandyTexs[(int)random(0, CandyTexs.length)]);
    Candies.add(p);
  }
  
  for (int i = Candies.size()-1; i >= 0; i--) 
  {
    Candy c = Candies.get(i);
    if (c.done()) 
    {
      Candies.remove(i);
      if(lifes == 0)
      {
        finishGame();
        return;
      }
    }
  }
}

void draw()
{ 
  update();
  
  background(0, 127, 255);
  sunRotation += 0.003 * clockwise;
  
  float pow = player.getAveragePower();
  //println(pow);
  if(pow > 0.265 && sunWait > 1.0f)
  {
    clockwise = clockwise == 1 ? -1 : 1;
    ufo.inverseDirection();
    sunRotation += clockwise * PI / 32;
    sunWait = 0.0f;
  }
  sunWait += 0.1f;
  ufo.move(0.003f);
  //sun
  pushMatrix();
  rotate(sunRotation * 5);
  imageMode(CENTER);
  image(SunPic, 0, 0);
  popMatrix();
  
  //grass
  imageMode(CORNER);
  image(GrassPic, 0, 0);
  
  //mouse drawing
  image(DrawingPic, 0, 0);
  if(displayMenu)
  {
    drawMenu();
  }
  else
  {
    for(Candy c: Candies) 
      c.display();
    
    ufo.display();
    
    lineManager.display();
    
    textSize(18);
    textAlign(LEFT);
    fill(0);
    text("Score : " + score, 10, 30);
    text("Lifes : " + lifes, 10, 58);
  }
}

void mouseMoved()
{
  lineManager.addSegment(pmouseX, pmouseY, mouseX, mouseY);
}

void mousePressed()
{
  if(btnStart.isPressed())
  {
    displayMenu = false;
    player.cue(0);
    player.play();
  }
}

void beginContact(Contact cp) 
{
    // Get both fixtures
    Fixture f1 = cp.getFixtureA();
    Fixture f2 = cp.getFixtureB();
    // Get both bodies
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    
    if(o1 == "ufo" && o2 instanceof Candy)
    {
      ((Candy)o2).removed = true;
    }
    else if(o2 == "ufo" && o1 instanceof Candy)
      {
        ((Candy)o1).removed = true;
      }
}

void endContact(Contact cp) 
{ }
