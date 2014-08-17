class Particle
{
  PVector position;
  PVector velocity;
  Particle()
  {
    //position = new PVector(random(0,width),random(0,height));
    position = new PVector(mouseX, mouseY);
    //position = new PVector((jQuery(window).width()/2),(jQuery(window).height()/2));
    velocity = new PVector(random(-1,1),random(-1,1));
  }
  void react(Particle [] chain, int me)
  {
    for (int i = me - 1; i <= me + 1; i++) {
      int i_c = (i + chain.length) % chain.length;
      if (i_c != me) {
        float d = PVector.dist(position,chain[i_c].position);
        // natural separation: 100 units
        // force on a spring: F=kx
        // x = displacement from equilibrium position
        //float x = d - 100.0;
        float x = d - 250.0;
        // apply force *along* the spring:
        PVector dir = PVector.sub(chain[i_c].position,position);
        dir.normalize();
        // F=ma should apply:
        // here we adjust the velocity according to the current force
        dir.mult(x/1000.0);
        velocity.add(dir);
      }
    }
    // bounce of the sides:
    bounce();
    // friction: dampen any movement:
    velocity.mult(0.999);
  }
  void move()
  {
    position.add(velocity);
  }
  void draw_springs(Particle [] chain, int me)
  {
    stroke(64); //16
    for (int i = me - 1; i <= me + 1; i++) {
      int i_c = (i + chain.length) % chain.length;
      if (i_c != me) {
        line(position.x+5,position.y+5,chain[i_c].position.x+5,chain[i_c].position.y+5);
      }
    }
  }
  void draw_particle()
  {
    noStroke();
    fill(255);
    rect(position.x,position.y,10,10);
    //rect(position.x,position.y,jQuery(window).width(),jQuery(window).height());

  }
  void draw_polygon()
  {
    vertex(position.x+5,position.y+5);
  }
  void bounce()
  {
    if (position.x < 0 && velocity.x < 0)
      velocity.x -= velocity.x;
    if (position.y < 0 && velocity.y < 0)
      velocity.y = -velocity.y;
    if (position.x > width && velocity.x > 0)
      velocity.x = -velocity.x;
    if (position.y > height && velocity.y > 0)
      velocity.y = -velocity.y;
  }
}

Particle [] chain;

int nodes = 18;
 
void setup()
{
// Gauge the proper height

if( jQuery(document).height() > jQuery(window).height() )
    setupHeight = jQuery(document).height();
else
    setupHeight = jQuery(window).height();

if( jQuery(document).width() > jQuery(window).width() )
    setupWidth = jQuery(document).width();
else
    setupWidth = jQuery(window).width();


jQuery('canvas').width(setupWidth);
jQuery('canvas').height(setupHeight);
size(setupWidth, setupHeight);


        
  //size(900,600);
  smooth();
  //chain = new Particle [5];
  chain = new Particle [nodes];
  for (int i = 0; i < chain.length; i++) {
    chain[i] = new Particle();
  }
}
 
void draw()
{
  background(0);
  for (int i = 0; i < chain.length; i++) {
    chain[i].react(chain,i);
  }
  for (int i = 0; i < chain.length; i++) {
    chain[i].move();
  }
  for (int i = 0; i < chain.length; i++) {
    chain[i].draw_springs(chain,i);
  }
  for (int i = 0; i < chain.length; i++) {
    chain[i].draw_particle();
  }
  /*
  fill(16);
  beginShape();
  for (int i = 0; i < chain.length; i++) {
    chain[i].draw_polygon();
  }
  endShape();
  */
}
 
void mouseClicked()
{
  for (int i = 0; i < chain.length; i++) {
    chain[i] = new Particle();
  }
}

void keyPressed() 
{
  if (nodes < 999) {
    nodes++;
  } else {
    nodes = 3;
  }
  setup();
}

