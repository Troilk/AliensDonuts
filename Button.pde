class Button
{
  PImage img;
  String text;
  int posX, posY;
  float highlightTime;
  int sizeX, sizeY;
  float[] tintVal = new float[] { 0, 0, 0 };
  
  Button(int posX, int posY, int sizeX, int sizeY, PImage img, String text, float highlightTime)
  {
    this.img = img;
    this.text = text;
    this.posX = posX;
    this.posY = posY;
    this.highlightTime = highlightTime;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  void update(float time)
  {
     int minTint = 127;
     float halfW = sizeX * 0.5;
     float halfH = sizeY * 0.5;
     float tintAmount = time * (1 / highlightTime) * (255 - minTint);
     if(mouseX < (posX - halfW) || mouseX > (posX + halfW) ||
        mouseY < (posY - halfH) || mouseY > (posY + halfH))
     {
       tintVal[0] = max(minTint, tintVal[0] - tintAmount);
       tintVal[1] = max(minTint, tintVal[1] - tintAmount);
       tintVal[2] = max(minTint, tintVal[2] - tintAmount);
     }
     else
     {
       tintVal[0] = min(255, tintVal[0] + tintAmount);
       tintVal[1] = min(255, tintVal[1] + tintAmount);
       tintVal[2] = min(255, tintVal[2] + tintAmount);
     }
  }
  
  boolean isPressed()
  {
    float halfW = sizeX * 0.5;
    float halfH = sizeY * 0.5;
    return (mouseX > (posX - halfW) && mouseX < (posX + halfW) &&
        mouseY > (posY - halfH) && mouseY < (posY + halfH));
  }
  
  void draw()
  {
    tint(tintVal[0], tintVal[1], tintVal[2]);
    imageMode(CENTER);
    image(img, posX, posY, sizeX, sizeY);
    float tSize = sizeY * 0.8;
    textSize(tSize);
    textAlign(CENTER, CENTER);
    text(text, posX, posY - sizeY * 0.1);
    noTint();
  }
}
