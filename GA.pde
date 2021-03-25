
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<PVector> best_genome = new ArrayList<PVector>();
ArrayList<PVector> best_genome_2 = new ArrayList<PVector>();
PVector target; 





void setup(){
  size(800,600);
  background(32);
  target = new PVector(100, 100);
  }
  
PVector wall_1a = new PVector(0, 400);
PVector wall_1b = new PVector(400, 400 );

PVector wall_2a = new PVector(300,0);
PVector wall_2b = new PVector(300,200);

int pop_size = 100;
boolean new_gen = true;
boolean first_gen = true;
int gen = 1;


void draw(){
  background(32);
  String str = "Generation "; 
  String.valueOf(gen);
  str = str + String.valueOf(gen);
  textSize(30);
  fill(255);
  text(str, 580,50);
  textSize(20);
  fill(0,255,0);
  text("Target",70,60);
  text("Start",100,550);
  
  
  
  //draw target
  stroke(0,255,0);
  fill(0,255,0);
  ellipse(target.x, target.y, 30,30);
  stroke(255);
  fill(255);
  ellipse(target.x, target.y, 20,20);
  stroke(0,255,0);
  fill(0,255,0);
  ellipse(target.x, target.y, 10,10);
  
  stroke(255);
  strokeWeight(5);
  
  // draw walls
  line(wall_1a.x, wall_1a.y, wall_1b.x, wall_1b.y);
  line(wall_2a.x, wall_2a.y, wall_2b.x, wall_2b.y);
  
  if(new_gen){
    for(int i =0 ; i < pop_size ; i++)
      particles.add(new Particle(first_gen, best_genome, best_genome_2));
  }
  new_gen = false;
  first_gen = false;
 
  for(int i =0 ; i < pop_size ; i++){
    particles.get(i).update();
    particles.get(i).show();
  }
  
  if(particles.get(1).is_alive() == false)
  {
    
    float score, temp;
    int i, best_index = 0, best_index_2 = 1;
    float best_score = particles.get(best_index).score();
    float best_score_2 = particles.get(best_index_2).score();
    
    gen ++;
    
    // sort first two best scores
    if(best_score_2 < best_score){
      temp = best_score_2;
      best_score_2 = best_score;
      best_score = temp;
      best_index = 1;
      best_index_2 = 0;
      
    }
    
    for(i = 2 ; i < pop_size ; i++)
    {
      score = particles.get(i).score();
      
      if(score < best_score)
      {
        temp = best_score;
        best_score = score;
        best_score_2 = temp;
        best_index_2 = best_index;
        best_index = i;
  
        best_genome = particles.get(best_index).genome;
        best_genome_2 = particles.get(best_index_2).genome;
        
       }
       
       else if(score < best_score_2){
         best_score_2 = score;
         best_index_2 = i;
         best_genome = particles.get(best_index).genome;
         best_genome_2 = particles.get(best_index_2).genome;
       }
    }
    
    particles = new ArrayList<Particle>();
    new_gen = true;
  }
  //saveFrame("ga_movie/ga_####.png");
}

class Particle{
  
  int step;
  int num_of_steps = 250;
  PVector pos;
  PVector vel;
  ArrayList<PVector> genome = new ArrayList<PVector>();
  
  Particle(boolean first_gen, ArrayList<PVector> best_genome, ArrayList<PVector> best_genome_2){
    
    this.step = 0;
    this.pos = new PVector(200,height-50);
    this.vel = new PVector(0,0);
    this.vel.normalize();
    float n = random(0,1);
    
    if(first_gen || n < 0.1){
      for(int i =0 ; i < num_of_steps ; i++)
      {
        PVector temp = new PVector(random(-1,1), random(-1,1));
        temp.normalize();
        this.genome.add(temp);
      }
    }
    else{
    float num; 
    for(int i =0 ; i < num_of_steps ; i++)
      {
        num = random(0,1);
        PVector b_g;
        float scale = 0.1;
        PVector noise = new PVector(random(-1,1), random(-1,1));
        noise.mult(scale);
        
        if(num < 0.5)
          b_g = best_genome.get(i);
        else 
          b_g = best_genome_2.get(i);
          
        this.genome.add(noise.add(b_g));
        
      }
    }
   }
  
  
  boolean is_alive(){
    if(this.step < this.num_of_steps)
      return true;
    else
      return false;
  }
  
  void update(){
    boolean alive = this.step < this.num_of_steps;
    boolean stuck_frame = (this.pos.x >= width || this.pos.x <= 0 || this.pos.y >= height || this.pos.y <= 0);
    boolean stuck_wall_1 = (this.pos.x >= wall_1a.x && this.pos.x <= wall_1b.x && this.pos.y >= wall_1a.y - 10 && this.pos.y <= wall_1b.y + 10);
    boolean stuck_wall_2 = (this.pos.x <= wall_2a.x +10 && this.pos.x >= wall_2b.x - 10 && this.pos.y >= wall_2a.y && this.pos.y <= wall_2b.y);
    
    boolean reached_target = this.pos.dist(target) < 10;
    
    if(alive && !stuck_frame && !stuck_wall_1 && !stuck_wall_2 && !reached_target)
    {
      this.vel = this.vel.add(genome.get(step));
      this.pos = this.pos.add(this.vel);
    }
    else if(stuck_wall_1)
    {
      this.vel.y = this.vel.y*(-1);
      this.pos = this.pos.add(this.vel);
    }  
    
    else if(stuck_wall_2)
    {
      this.vel.x = this.vel.x*(-1);
      this.pos = this.pos.add(this.vel);
    } 
     step += 1;
  }
  
  void show(){
    stroke(255,0,255);
    fill(255,0,255);
    ellipse(this.pos.x, this.pos.y, 10,10);
  }
  
  float score(){
    return pos.dist(target);
  }
  
}

  
  
  
  
