import oscP5.*;
import netP5.*;
float phase = 0;
float freq = 110;
float amp_left = 0;
float amp_right = 0;

float phaseInvert;
float speed;
float moveX = 0;

float phase01;
float fColor;
float ampSubL;
float ampSubR;

int posL;
int poR;

int cSize;
float waveSize;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup(){
  fullScreen();
  //size(400, 400);
  background(#FFFFFF);
  colorMode(HSB, 360, 100, 100, 100);  
  
  oscP5 = new OscP5(this,12000);

  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  posL = height/4;
  poR =  height - height/4;

  cSize = height - height/10;
  waveSize = height/100;
}

void draw(){
  background(0, 60, 100);
  noStroke();
  
  
  fill(freq*360, fColor, 100, abs(ampSubL*50 + (ampSubR*phaseInvert)*50) );
  circle(width/2, height/2, cSize*freq);
  circle(width/2, height/2, cSize*freq/2);
  circle(width/2, height/2, cSize*freq/3);
   circle(width/2, height/2, cSize*freq/4);
    circle(width/2, height/2, cSize*freq/5);
 
  fill(0, 60, 100);
 
  float x = (0 - width);
  while(x< width){ //point(dibujo, posicion + amp * sin(dibujo/frequencia + fase))
    circle(x + speed, height/2 + (amp_left+amp_right*phaseInvert) * sin(x*(freq*0.28)+phaseInvert*5), waveSize);
    
    circle(x + speed, height/4 + amp_left * sin(x*(freq*0.28)), 5);
    circle(x + speed, (height - height/4) + amp_right * sin(x*(freq*0.28)+phase), waveSize);
    x += 0.5;
  
  } 
  
  speed += moveX;
  if (speed>width) speed = 0;
  }
  
  void oscEvent(OscMessage theOscMessage) {

if(theOscMessage.checkAddrPattern("/phase_mod")==true) {
phase = theOscMessage.get(0).floatValue();

phase01 = map(phase, 0.005, 0.5, 0, 1);
phaseInvert = map(phase, 0.005, 0.5, 1, -1);
phase = map(phase, 0.005, 0.5, 0, 5);

println(" phase: " +phase);
return;
}
if(theOscMessage.checkAddrPattern("/freq")==true) {

  if(theOscMessage.checkTypetag("i")) freq = theOscMessage.get(0).intValue();

  else if (theOscMessage.checkTypetag("f")) freq = theOscMessage.get(0).floatValue();
  moveX = map(freq, 0, 440, 0, 20);
  fColor = map(freq, 0, 440, 0, 100);
  freq = map(freq, 0, 440, 0, 1);

  println(" freq: " +freq);
  return;
}
if(theOscMessage.checkAddrPattern("/amp_left")==true) {
amp_left = theOscMessage.get(0).floatValue();
ampSubL = map(amp_left, 0.01, 0.999, 0, 1);
amp_left = map(amp_left, 0.01, 0.999, 0, 20);

println(" amp_left: " +amp_left);
return;
}
if(theOscMessage.checkAddrPattern("/amp_right")==true) {

amp_right = theOscMessage.get(0).floatValue();
ampSubR = map(amp_right, 0.01, 0.999, 0, 1);
amp_right = map(amp_right, 0.01, 0.999, 0, 20);

println(" amp_right: " +amp_right);
return;
}
}
