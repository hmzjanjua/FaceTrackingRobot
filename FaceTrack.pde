import gab.opencv.*;
import java.awt.Rectangle;
import processing.serial.*;
import processing.video.*;

OpenCV opencv;
Serial Eve_Port;
Rectangle[] faces;
Capture video;

int avgX;
int avgY;

void setup() {
  size(320 , 240);
  video = new Capture(this,320,240,30);
  opencv = new OpenCV(this, 320, 240);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  
  video.start();
   
  Eve_Port = new Serial(this, "COM4", 9600);
  Eve_Port.bufferUntil('\n');
   
  faces = opencv.detect();
}

void draw() {
  if(video.available()){
    video.read();
  }
  scale(1);
  opencv.loadImage(video);
  image( video, 0, 0 );
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
  
    println(faces[i].x + "," + faces[i].y + "," + faces[i].width + "," + faces[i].height);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
               
    avgX = faces[i].x + faces[i].width/2;
    avgY = faces[i].y + faces[i].height/2;
     
    fill(255);
    strokeWeight(2.0);
    stroke(0);
    ellipse(avgX, avgY, 8, 8);
       
    stroke(255, 0, 0);
    point(avgX, avgY);
    avgX = ( avgX * 100 / 177 );
    avgY = ( avgY * 100 / 133 );
        
    Eve_Port.write(avgX);
    Eve_Port.write(avgY);
  }
}
