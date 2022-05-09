//< THEME : Generative art, Animation on three dimensions, Image processing > 

int deg1 = 0;//degree
int node_count = 1500; //the number of nodes
float sphereSize1 = 30; //for the fist size of a center sphere
float minLength = 10; // minimum distance between nodes
float maxLength = 50; //  maximum distance between nodes
node[] nodes = new node[node_count]; //for node class
PImage galaxyImg; //for background image
PImage rainbow2Img; //for texture image
PShape sphere; //texture for sphere 
boolean isAxis = true; //for xyz axis
PFont font;

void setup(){
  size(900, 700, P3D);
  
  galaxyImg = loadImage("galaxy.jpg"); //texture image
  rainbow2Img = loadImage("rainbow2.jpg"); //texture image
  
  for(int i=0; i < node_count; i++){  //the number of nodes
    nodes[i] = new node(); 
  }
  
  smooth();
  frameRate(20);
  font = createFont("MS Gothic",48);
  textFont(font);
}

class node{
  float x1,x2,y1,y2,z1,z2;
  
  //generate node coodinates
  void nodeCoodinate(){
    
    float z_ran = random(-1,1); //uniform distribution
    float angle = radians(random(360)); //random φ limited from 0° to 360°
    float r; //radius of spheres
    
    //in the case of radius
    if(random(3) < 0.4){
      r = 90;
    }
    else if(0.4 <= random(3) && random(3) < 1.2){
      r = random(15)+160;
    }
    else{
      r = random(25)+220;
    }
    
    //calculation to distribute the nodes uniformly on the sphere
    x2 = r*cos(angle)*sqrt(1-pow(z_ran,2));
    y2 = r*sin(angle)*sqrt(1-pow(z_ran,2));
    z2 = r*z_ran;
  }
  
  node(){ //constructor
    nodeCoodinate();
    x1 = z2;
    y1 = y2;
    z1 = z2;
  }
  
  void createNode(){  //function for creating nodes 
    if(mouseButton == LEFT) //update  node coodinates
       nodeCoodinate();
      
      //move nodes little by little
      x1 += 0.3*(x2-x1);  
      y1 += 0.1*(y2-y1);
      z1 += 0.3*(z2-z1);
    
    // create nodes and adjust color
    
    //green
    if(random(3) < 1.0){
      
      pushMatrix();
      
        lightSpecular(255, 255, 255);
        ambient(150, 100, 0);
        specular(100, 240, 0);
        emissive(100, 240, 34);
        shininess(2);
        
        translate(x1,y1,z1);
        sphere(random(4)+1);      
        
      popMatrix();
    
    
    }//blue
    else if(1.0 <= random(3) && random(3) < 2.0){
      
      pushMatrix();
    
        lightSpecular(255, 255, 255);
        ambient(0, 100, 150);
        specular(0, 147, 190);
        emissive(34, 210, 250);
        shininess(4);
        
        translate(x1,y1,z1);
        sphere(random(4)+1);      
      
      popMatrix();
      
    
    }//red(pink)
    else{
      
      pushMatrix();
    
        lightSpecular(255, 255, 255);
        ambient(150, 125, 125);
        specular(190, 90, 90);
        emissive(210, 90, 90);
        shininess(2);
        
        translate(x1,y1,z1);
        sphere(random(4)+1);      
      
      popMatrix();
      
    }
  }
}


//function for setting xyz axis
void axis(char s, color c){
  int len = 500;
  fill(c); stroke(c);
  
  pushMatrix();
    if(isAxis){
      box(len, 1, 1);
      
      pushMatrix();
        translate(len / 2, 0, 0);
        sphere(3);
        text(s, 5, -5, 0);
      popMatrix();
    }
  popMatrix();
  
}

//function for drawing xyz axis
void drawAxis(char s, color c){
  switch(s){
    
    case 'X':
      axis(s, c);
      break;
      
    case 'Y':
      pushMatrix();
        rotateZ(PI / 2);
        axis(s, c);
      popMatrix();
      break;
      
    case 'Z':
      pushMatrix();
        rotateY(-PI / 2);
        axis(s, c);
      popMatrix();
      break;
  }
}

//processing when 'a' key is pressed
void keyPressed(){
  switch(key){
    case 'a':
      if(isAxis) isAxis = false;
      else isAxis = true;
      break;
  }
}


//function for drawing center sphere and rotating sphere
void drawSphere(){
  
   pushMatrix();
    
    ambientLight(50,50,50);
    directionalLight(255, 0, 255, map(mouseX, 0, width, 1, -1), map(mouseY, 0, height, 1, -1), -1);
    lightSpecular(255, 255, 255);
    ambient(187, 87, 151);
    specular(255, 255, 255);
    emissive(245,245, 255);
    shininess(1);
    
    sphereDetail(6,3);
    
    rotateY(-deg1*PI/180); 
    deg1+=7;
    
    if(mouseButton == LEFT) //randomly change the radius of the central sphere when the left mouse button is clicked
        sphereSize1 = random(65)+10;
    
    sphere = createShape(SPHERE,sphereSize1); 
    sphere.setTexture(rainbow2Img);  //sphere texture
    sphere.setStrokeWeight(0); 
    
    shape(sphere);
    
    directionalLight(255, 0, 150, map(mouseX, 0, width, 1, -1), map(mouseY, 0, height, 1, -1), -1);
    ambient(187, 87, 151);
    specular(230, 190, 0);
    emissive(147, 109, 0);
    shininess(2);

    translate(140, 0, 140);
    sphereDetail(2,2);
    sphere(20);
    
  popMatrix();
  
}

float degN = 0;
//function for drawing my name and student id number
void drawName(){
   pushMatrix();
 
    rotateZ(-degN*PI/180);
    degN+=2;
    
    fill(255,255,255,255);
    String s = "@shwg8986";
    float r = 2.3*textWidth(s)/ PI,theta = PI / s.length();
    for(int i=0;i<s.length();i++){
      pushMatrix();
        translate(-r*cos(theta*i),-r*sin(theta*i),0);
        rotateZ(theta *i-PI/2);
        text(s.charAt(i),0,0,0);
      popMatrix();
    }
   popMatrix();
}


void draw(){
  noStroke();
  background(0);
  
  loadPixels();  //set background-image
  
  galaxyImg.loadPixels();  
  for(int i=0; i < galaxyImg.width * galaxyImg.height; i++){
    pixels[i] = galaxyImg.pixels[i];  
  }
  
  updatePixels();  
   
  drawSphere(); //call function
  
  drawName(); // call function
  
  //comparison each nodes by total hits
  for(int i=0; i < node_count; i++){
    for(int j=i; j < node_count; j++){
      
      //calculation the distance between nodes on three dimensions
      float Length = sqrt(pow(nodes[i].x1-nodes[j].x1,2)+pow(nodes[i].y1-nodes[j].y1,2)+pow(nodes[i].z1-nodes[j].z1,2));
      
      //condition of node distance
      if(minLength <= Length && Length < maxLength){
        strokeWeight(map(Length, maxLength, minLength, 0.3, 5));
        stroke(map(Length, minLength, maxLength, 100, 255),map(Length, minLength, maxLength, 50, 255),255,120);
       
        //generate lines to connect nodes.
        line(nodes[i].x1,nodes[i].y1,nodes[i].z1,nodes[j].x1,nodes[j].y1,nodes[j].z1);
      }
    }nodes[i].createNode();  //call function in class
  }
  
  //viewing transformation
  float cameraY = map(mouseY, 0, height/3, 400, -200);
  float Theta = map(mouseX, 0, width/3, 0, radians(360));
  camera(400 * cos(Theta), cameraY, 400 * sin(Theta), 0, 0, 0, 0, -1, 0);
  
  //draw xyz axis
  pushMatrix();
    drawAxis('X', color(255, 0, 0));
    drawAxis('Y', color(0, 255, 0)); 
    drawAxis('Z', color(0, 0, 255)); 
  popMatrix();
  
}
