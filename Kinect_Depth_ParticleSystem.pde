import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

ArrayList<Particle> particles;

int closestValue;
int closestX;
int closestY;

float deg;
boolean ir = false;
boolean colorDepth = false;
boolean mirror = false;

void setup() {
  //size(1280, 520);
  size(640,360);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  //kinect.enableIR(ir);
  kinect.enableColorDepth(colorDepth);
  deg = kinect.getTilt();
  // kinect.tilt(deg);
  
  particles = new ArrayList<Particle>();
}

void draw() {
  background(0);
  //image(kinect.getVideoImage(), 0, 0);
  //image(kinect.getDepthImage(), 640, 0);
  fill(255);
  text(
    "Press 'i' to enable/disable between video image and IR image,  " +
    "Press 'c' to enable/disable between color depth and gray scale depth,  " +
    "Press 'm' to enable/diable mirror mode, "+
    "UP and DOWN to tilt camera   " +
    "Framerate: " + int(frameRate), 10, 515);
    
  closestValue = 4000;
  int[] depthValues = kinect.getRawDepth();
  for (int y = 0; y<360; y++) {
    for (int x = 0; x<640; x++) {
      int i = x + y*640;
      int currentDepthValue = depthValues[i];

      if (currentDepthValue>0 && currentDepthValue < closestValue) {
        closestValue = currentDepthValue;
        closestX = x;
        closestY = y;
      }
    }
  } 
  image(kinect.getDepthImage(), 0, 0);
  particles.add(new Particle(new PVector(closestX, closestY)));

  for (int i=0; i<particles.size (); i++) {
    Particle p = particles.get(i);
    p.run();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
  //image(kinect.depthImage(),0,0);
  // fill(155,150,200);
  // ellipse(closestX, closestY,25,25);
}

void keyPressed() {
  if (key == 'i') {
    ir = !ir;
    kinect.enableIR(ir);
  } else if (key == 'c') {
    colorDepth = !colorDepth;
    kinect.enableColorDepth(colorDepth);
  } else if (key == 'm') {
    mirror = !mirror;
    kinect.enableMirror(mirror);
  } else if (key == CODED) {
    if (keyCode == UP) {
      deg++;
    } else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg, 0, 30);
    kinect.setTilt(deg);
  }
}