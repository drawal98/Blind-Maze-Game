import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
ball player;
ArrayList <wall> walls=new ArrayList<wall>(); 
ArrayList <soundPart> permanent= new ArrayList<soundPart>();
 Minim minim;
AudioInput input;
float amplitude;
float amp2, amp3;


void setup() {
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO,512);
  amplitude = 0.0;
  amp2=0.0;
  amp3=0.0;
 
   pixelDensity(2);
  //size(1000, 800);
   fullScreen(P2D);
  player = new ball(50,100);
 
  walls = drawWalls();
  
  
} 

ArrayList<wall> drawWalls(){
    ArrayList<wall> w = new ArrayList<wall>();
    w.add(new wall(0,120,40,height));
    w.add(new wall(width-40,0,40,height-120));
    w.add(new wall(0,0,width, 40));
    w.add(new wall(0,height-40,width,40));
    
    for(int x = 100; x<width-80; x+=100){
      float y = random(2);
      if(y>1){
         w.add(new wall(x,0,40,random(400,height-80)));
      }
      else{
        w.add(new wall(x,random(400, height),40,random(200,height)));
      }
    }
    
    return w;
  }
  
  void reset(){
    background(0);
    walls = drawWalls();
    player = new ball(50,100);
    permanent = new ArrayList<soundPart>();
    
    
  }

void draw() {
 
  background(0); 
  noStroke(); 
  amplitude=abs(input.left.get(0)*500);
  if(amplitude>amp2){
    amp2=amplitude;
  }
  amp2*=.95;
  amp3+=(amplitude-amp3)*0.05;
 
  player.draw();
  player.move(walls);

 
 pushStyle();
  stroke(255);
  fill(155);
  for(int p = 0; p<permanent.size(); ){
    if(permanent.get(p).getRadius()<1){
      permanent.remove(p);
    }
    else{
         float R = amp3;
    permanent.get(p).changeColor(R);
    permanent.get(p).draw();
    permanent.get(p).changeRadius();
   // float R = amp3;
     permanent.get(p).increase(R);
    p++;
    
    }
  }
  
  
  popStyle();

  for(int i = 0; i < walls.size(); i++){
    
    walls.get(i).draw();
  }
  
  
  if(mousePressed){
    reset();
  }
  
}

class ball {
 
  float x;
  float y;
 
  ball(float _x, float _y){
    x = _x;
    y = _y;
  }
 
  void draw(){
    fill(128);
    ellipse(x,y,25,25);
  }
 
  void move(ArrayList<wall> walls){
 
    float possibleX = x;
    float possibleY = y;
 
    if (keyPressed==true) {
 
      println(key);
 
      if (key=='a') { 
        possibleX= possibleX - 5;
      } 
      if (key=='d') { 
        possibleX = possibleX + 5;
      } 
      if (key=='w') { 
        possibleY = possibleY - 5;
      } 
      if (key=='s') { 
        possibleY = possibleY + 5;
      }
      if(key=='e'){
          soundPart pa = new soundPart(x,y);
          pa.move(walls);
      }
    }

    boolean didCollide = false;
    for(int i = 0; i < walls.size(); i++){
      if(possibleX > walls.get(i).x && possibleX < (walls.get(i).x + walls.get(i).w) && possibleY > walls.get(i).y && possibleY < walls.get(i).y + walls.get(i).h){
        didCollide = true;
      }
    }
 
    if(didCollide == false){
      x = possibleX;
      y = possibleY;
    }
 
  if(x>width){
    x=-10;
    y=100;
    for(wall W : walls){
      W.opposite();
    }
  }
  
  if(x<-80){
    reset();
  }
  }
  
 
}
 
class wall {
 
  float x;
  float y;
  float w;
  float h;
  boolean c =false;
  int colr = 0; 
 
  wall(float _x, float _y, float _w, float _h){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
 
  void draw(){
    fill(colr);
    noStroke();
    rect(x,y,w,h);
  }

  void opposite(){
    c=!c;
    if(c==true){
      colr=255;
    }
    else{
      colr=0;
    }
  }
}


class soundPart{
  float c;
  float x;
  float y;
  float xReal;
  float yReal;
  float rad;
  color k;
  
  soundPart(float _x, float _y){
    xReal=_x;
    yReal=_y;
    x=0;
    y=0;
    rad=20;
    c=0;
  }
  
  
  void draw(){
    pushStyle();
     colorMode(HSB,100);
     //fill(0, 50);
     ellipseMode(CENTER);
     color r = color(100,c,80);
     fill(r);
     stroke(r);
     ellipse(xReal,yReal,rad,rad);
     popStyle();
  }
  
  void move(ArrayList<wall> walls){
      float pX=0;
      float pY=0;
   
    boolean didCollide = false;
    for(int j =0; j<20; j++){
      pX=0;
      pY=0;
      float theata=(PI/20)*j;
      float xStep=cos(theata+(frameCount*0.05));
      float yStep=sin(theata+(frameCount*0.05));
      didCollide=false;
    int stepCount =0;
      while(!didCollide&& stepCount<600){
       
      pX+=xStep;
      pY+=yStep;
      xReal+=xStep;
      yReal+=yStep;
      stepCount++;
      pushMatrix();
        translate(xReal,yReal);
         ellipseMode(CENTER);
        noStroke();
        ellipse(0,0,2,2);
        for(int i = 0; i < walls.size(); i++){
          if(xReal > walls.get(i).x && xReal < (walls.get(i).x + walls.get(i).w) && yReal > walls.get(i).y && yReal < walls.get(i).y + walls.get(i).h){
            didCollide = true;
            permanent.add(new soundPart(xReal,yReal));
            stroke(0);
           i=walls.size();
          }
        }
        
  popMatrix();

  }
}
  
  }
  
  float getRadius(){
    return rad;
  }
  
  void changeRadius(){
    rad--;
  }
  
  void increase(float amp){
    rad=rad+amp;
    if(rad>40){
      rad=39;
    }
    changeRadius();
  }
  
  void changeColor(float amp){
    if(c>=100){
      c=c-amp;
    }
    else{
       c=c+amp;
    }
    changeRadius();
  }
  
}
  