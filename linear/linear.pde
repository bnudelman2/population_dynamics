int stage = 0;
int iterations = 5; //number of iterations in which the matrix is multiplied
float[] next_population = new float[4];
float[] F = new float[4];
PMatrix3D H = new PMatrix3D();
float[] rounded_population = new float[4];

void setup() {
  background(#C9EDCA);
  size(1200,800);
  
  PMatrix3D interactions = new PMatrix3D();
  interactions.set(0, -0.2, -0.1, -0.02, 0.1, 0, -0.4, -0.3, 0.08, 0.3, 0, 0, 0.01, 0.25, 0, 0);

  //interactions.print(); //for testing
  float[] growth_death_rate = new float[]{0.8,0.4,0.3,0.2}; //temp, will set later

  float[] initial_population = new float[]{50, 25, 10, 5};

  float dt = 0.02; //this keeps track of the timestep

  //float[] ones = new float[]{1 , 1 , 1 , 1};

  H = interactions.get();
  H.scale(dt);

  for (int i = 0; i < F.length; i++) {
    F[i] = growth_death_rate[i];
  }

  for (int i = 0; i < F.length; i++) {
    F[i] *= dt;
    F[i] += 1;
  }

  for (int i = 0; i < next_population.length; i++) {
    next_population[i] = initial_population[i];
  }
  
  for (int i = 0; i < rounded_population.length; i++) {
    rounded_population[i] = initial_population[i];
  }
  
  //printArray(next_population);

  //printArray(ones);
}

void updatePopulation(){
    //printArray(next_population);
    PMatrix3D H_copy = H.get();
    float[] step_0 = new float[4];
    H_copy.mult(next_population, step_0);

    float[] step_1 = new float[4];
    for (int i = 0; i < step_1.length; i++) {
      step_1[i] = step_0[i] + F[i];
    }

    for (int i = 0; i < next_population.length; i++) {
      next_population[i] = step_1[i] * next_population[i];
      if (next_population[i] < 0){
        next_population[i] = 0;
      }
    }
    
    for (int i = 0; i < next_population.length; i++){
      rounded_population[i] = round(next_population[i]);
    }
    
    //printArray(rounded_population);
}

void keyPressed(){
  if (key == ' '){
    if (stage != 5){
      //print(stage + 1);
      stage++; //stages go from zero to n
      updatePopulation();
    }
  }
}

void draw(){
  //reset right side background
  stroke(#FFE2FB);
  fill(#FFE2FB);
  rect(800,0,400,1200);
  
  //write the stage on the top right
  fill(0);
  textSize(64);
  text("Stage: ", 870, 100);
  text(stage, 1080, 100);
  
  //write the population matrix under the stage
  PImage wolf = loadImage("wolf.png");
  PImage hawk = loadImage("hawk.png");
  PImage rabbit = loadImage("rabbit.png");
  PImage grass = loadImage("grass.png");
  
  image(grass, 870, 170, 100,100);
  image(rabbit, 870, 320, 100, 100);
  image(wolf, 870, 470, 100, 100);
  image(hawk, 870, 620, 100, 100);
  
  stroke(0);
  strokeWeight(15);
  fill(#FFE2FB);
  rect(1000,150,180,600);
  stroke(#FFE2FB);
  rect(1030,130,120,30);
  rect(1030,730,120,30);
  
  //write populations in the matrix
  fill(0);
  text(str(rounded_population[0]), 1040, 260);
  text(str(rounded_population[1]), 1040, 410);
  text(str(rounded_population[2]), 1040, 560);
  text(str(rounded_population[3]), 1040, 710);
  
  fill(#C9EDCA);
  strokeWeight(5);
  stroke(#C9EDCA);
  rect(0,0,800,800);
  randomSeed(stage * 255); //generate new random seed
  
  for (int i = 0; i < rounded_population[3]; i++){
    float x = random(0,725);
    float y = random(0,725);
    
    image(hawk,x,y,75,75);
  }
  
  for (int i = 0; i < rounded_population[2]; i++){
    float x = random(0,700);
    float y = random(0,700);
    
    image(wolf,x,y,100,100);
  }
  
  for (int i = 0; i < rounded_population[1]; i++){
    float x = random(0,750);
    float y = random(0,750);
    
    image(rabbit,x,y,50,50);
  }
  
  for (int i = 0; i < rounded_population[0]; i++){
    float x = random(0,750);
    float y = random(0,750);
    
    image(grass,x,y,50,50);
  }
}
