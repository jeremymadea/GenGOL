/*
 * Generalized Conway's Game of Life Cellular Automata  
 * 
 * Keystroke commands: 
 * space - pick a new random rule set and randomize the world with the current 
 *         population density. 
 * v     - print the current rule/settings in saveable format. 
 * C     - print the current running cell population density. 
 * W,w   - reduce the population density by 10 or 1% and randomize the world. 
 * E,e   - increase the population density by 10 or 1% and randomize the world.
 * D,d   - Cycle through the demo rule sets. 
 * U,u   - reduce the rule density by 10 or 1%. 
 * I,i   - increase the rule density by 10 or 1%.
 * p     - pause/unpause 
 * r     - randomize the world.  
 * s     - step through paused world one iteration at a time. 
 * k,K   - increase or descrease the iterations skipped between display. Default is 0. 
 *         Range is 0-10. Can help determine period of some blinkers, etc. 
 * t     - Start with a single cell in the middle of the world. 
 * T     - Start with a 40x40 centered square randomized using population density.
 * x     - swap dead and live cell colors.
 * !     - Enter debug mode. (After which mouse clicks report info.) 
 * z     - (Experimental) spawn new rules based on random rotations and mutation. 
 * 
 */
 
boolean debug = false; 
int set_width = 640; 
int set_height = 480; 
int cell_size = 2;

CARules rules; 
int world[][]; 
int world_buf[][];
int world_tmp[][]; 
int world_width = set_width / cell_size; 
int world_height = set_height / cell_size; 

int population_density = 25; // default pd
int rule_density = 50; 
int skip_iters = 0; 
boolean constant_mutation = false;
int mutation_probability = 50;
int dead = 0;   // Color of dead cells
int live = 255; // Color of live cells

CADemo[] ca_demos; 

void randomize_world(int density) { 
  for (int x=0; x<world_width; x++) {
    for (int y=0; y<world_height; y++) {
      world[x][y] = density > random(100) ? 1 : 0; 
    }
  }
}

void mutate_world(int prob) { 
  for (int x=0; x<world_width; x++) { 
    for (int y=0; y<world_height; y++) {
      world[x][y] = prob > random(100) ? abs(world[x][y] - 1) : world[x][y];
    }
  }
}

void clear_world() {
  for (int x=0; x<world_width; x++) {
    for (int y=0; y<world_height; y++) {
      world[x][y] = 0; 
    }
  } 
}  

void randomize_world_block(int density) {
  clear_world(); 
  for (int x=world_width/2-20; x<world_width/2+20; x++) {
    for (int y=world_height/2-20; y<world_height/2+20; y++) {
      world[x][y] = density > random(100) ? 1 : 0; 
    }
  }
}

void single_cell_world() {
  clear_world(); 
  world[world_width/2][world_height/2] = 1;
}


// The following two functions are used to treat the world as a torus. 
int xcoord(int x) {
  if (x < 0) { return x + world_width; } 
  if (x >= world_width ) { return x - world_width; }
  return x; 
}

int ycoord(int y) {
  if (y < 0) { return y + world_height; }
  if (y >= world_height) { return y - world_height; }
  return y; 
}

void load_demo(int index) {
  rules.load_rules(ca_demos[index].rules);
  skip_iters = ca_demos[index].skip_iters; 
  population_density = ca_demos[index].population_density; 
  switch (ca_demos[index].init_type) { 
    case CADemo.INIT_WORLD_RANDOM:
      randomize_world(population_density);
      break;  
    case CADemo.INIT_WORLD_RANDOM_BLOCK:
      randomize_world_block(population_density); 
      break; 
    case CADemo.INIT_WORLD_SINGLE_CELL:
      single_cell_world(); 
      break;    
  } 
  println(ca_demos[index].comment);
}


void load_demo_file() {
 JSONArray jarr = loadJSONArray("data/ca_demos.json"); 
 ca_demos = new CADemo[jarr.size()]; 
 for (int i=0; i<jarr.size(); i++) {
   ca_demos[i] = new CADemo(jarr.getJSONObject(i));
 }
}

void setup() {
  //size(set_width, set_height, P2D);
  size(640, 480, P2D);
  load_demo_file(); 

  rules = new CARules(CARules.SYMMETRY_NONE); 
  rules.randomize(50);
  
  world     = new int[world_width][world_height]; 
  world_buf = new int[world_width][world_height];  
  randomize_world(population_density);

}

void iterate() {
  int b[] = new int[8]; 
  int Lx, Hx, Ly, Hy; 
 
  for (int x=0; x < world_width; x++) { 
   for (int y=0; y < world_height; y++) {   
      Lx = xcoord(x-1); 
      Hx = xcoord(x+1); 
      Ly = ycoord(y-1); 
      Hy = ycoord(y+1); 
      b[0] = world[ Lx ][ Ly ]; 
      b[1] = world[ x  ][ Ly ]; 
      b[2] = world[ Hx ][ Ly ]; 
      b[3] = world[ Hx ][ y  ]; 
      b[4] = world[ Hx ][ Hy ]; 
      b[5] = world[ x  ][ Hy ]; 
      b[6] = world[ Lx ][ Hy ]; 
      b[7] = world[ Lx ][ y  ];
      world_buf[x][y] = rules.apply(world[x][y], b);
    }
  } 
  world_tmp = world; 
  world = world_buf;  
  world_buf = world_tmp;
}

void draw() { 
  iterate();
  for (int k=0; k < skip_iters; k++) {
    iterate(); 
  }
  if (constant_mutation) { 
    mutate_world(mutation_probability); 
  }
  background(0);
  //stroke(64);
  noStroke();
  for (int x=0; x < world_width; x++) { 
    for (int y=0; y < world_height; y++) { 
      if (world[x][y]==1) {
        fill(live); 
      } else { 
        fill(dead); 
      } 
      rect(x*cell_size, y*cell_size, cell_size, cell_size); 
    }
  }  
}

int ca_demo_index = -1; 
void keyPressed() { 
  if (key == ' ') { 
   rules.randomize(rule_density);
   randomize_world(population_density);
   
  } else if (key == 'd') { 
    ca_demo_index = (ca_demo_index + 1) % ca_demos.length; 
    load_demo(ca_demo_index); 
    
  } else if (key == 'D') { 
    ca_demo_index -= 1; 
    if (ca_demo_index < 0) ca_demo_index = ca_demos.length - 1; 
    load_demo(ca_demo_index); 
   
  } else if (key == 'w') {
    population_density = (101 + (population_density - 1)) % 101;
    println("Population density: " + population_density); 
    randomize_world(population_density);
  } else if (key == 'W') {
    population_density = (101 + (population_density - 10)) % 101;
    println("Population density: " + population_density); 
    randomize_world(population_density);
  } else if (key == 'e') {
    population_density = (population_density + 1) % 101;
    println("Population density: " + population_density); 
    randomize_world(population_density);
  } else if (key == 'E') {
    population_density = (population_density + 10) % 101;
    println("Population density: " + population_density); 
    randomize_world(population_density);
    
  } else if (key == 'u') {
    rule_density = (101 + (rule_density - 1)) % 101;
    println("Rule density: " + rule_density); 
    rules.randomize(rule_density);    
  } else if (key == 'U') { 
    rule_density = (101 + (rule_density - 10)) % 101;
    println("Rule density: " + rule_density); 
    rules.randomize(rule_density);
  } else if (key == 'i') { 
    rule_density = (rule_density + 1) % 101;
    println("Rule density: " + rule_density); 
    rules.randomize(rule_density);
  } else if (key == 'I') {
    rule_density = (rule_density + 10) % 101;
    println("Rule density: " + rule_density); 
    rules.randomize(rule_density);
    
  } else if (key == 'K') { 
    skip_iters = (10 + (skip_iters - 1)) % 10;
    println("Skip iters: " + skip_iters);
  } else if (key == 'k') {
    skip_iters = (skip_iters + 1) % 10;
    println("Skip iters: " + skip_iters);
    
  } else if (key == 't') {
    single_cell_world();
  } else if (key == 'T') { 
    randomize_world_block(population_density);   
  } else if (key == 'r') { 
    randomize_world(population_density);
  } else if (key == 'R') {
    rules.set_symmetry(CARules.SYMMETRY_NONE);
    rules.randomize(rule_density);
  } else if (key == '<' || key == ',') { 
    mutation_probability = (mutation_probability - 1) % 101 ;
    println("MP: " + mutation_probability);
  } else if (key == '>' || key == '.') {
    mutation_probability = (mutation_probability + 1) % 101 ;
    println("MP: " + mutation_probability);
  } else if (key == 'm'){
    mutate_world(mutation_probability); 
  } else if (key == 'M') {
    constant_mutation = !constant_mutation;
  } else if (key == 'p') { // Pause
    if (looping) { noLoop(); } else { loop(); }
    
  } else if (key == 'v') { 
    println ("-- Current Settings --");
    println('{');
    rules.print_rule_set_json();
    println("    \"skip\": " + skip_iters + ","); 
    println("    \"pd\": " + population_density + ",");
    println("    \"init\": 2,");
    println("    \"comment\": \"\"");
    println("}");
  } else if (key == 'c') { 
    // 
  } else if (key == 'C') {
    int cpd = 0; 
    for (int x=0; x<world_width; x++) {
      for (int y=0; y<world_height; y++) { 
        cpd+=world[x][y]; 
      }
    }
    println ("Running density: " + (100 * cpd / (world_width * world_height)));        
  } else if (key == '!') { 
    debug = !debug;
    
  } else if (key == 's') {
    redraw();
    
  } else if (key == '_') { 
    stroke(64); 
  } else if (key == '-') { 
    noStroke();
    
  } else if (key == 'x') { 
    if (dead == 0) { 
      dead = 255; 
      live = 0; 
    } else { 
      dead = 0; 
      live = 255;
    }
    
  } else if (key == 'z') { 
     rules = rules.spawn(); 
     randomize_world(population_density); 
     
  } else if (key >= '0' && key <= '9') {
    //
  } 
} 

void mouseReleased() {
 if (!debug) return; 
 
 int x = floor(mouseX/cell_size);
 int y = floor(mouseY/cell_size); 
 int b[] = new int[8]; 
 
  println("center:("+ x + "," + y + "); "
        + "box:(" + xcoord(x-1) + "," + ycoord(y-1) 
        + ") - (" + xcoord(x+1) + "," + ycoord(y+1) + ")"
        ); 
  
  b[0] = world[ xcoord(x-1) ][ ycoord(y-1) ]; 
  b[1] = world[ x           ][ ycoord(y-1) ]; 
  b[2] = world[ xcoord(x+1) ][ ycoord(y-1) ]; 
  b[3] = world[ xcoord(x+1) ][ y           ]; 
  b[4] = world[ xcoord(x+1) ][ ycoord(y+1) ]; 
  b[5] = world[ x           ][ ycoord(y+1) ]; 
  b[6] = world[ xcoord(x-1) ][ ycoord(y+1) ]; 
  b[7] = world[ xcoord(x-1) ][ y           ];   
  println("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"); 
  println( xcoord(x-1) + "," + ycoord(y-1) + "=" + b[0] + " "
         + x           + "," + ycoord(y-1) + "=" + b[1] + " " 
         + xcoord(x+1) + "," + ycoord(y-1) + "=" + b[2]);
               
  println( xcoord(x-1) + "," + y           + "=" + b[7] + " "
         + x           + "," + y           + "=" + world[x][y] + " " 
         + xcoord(x+1) + "," + y           + "=" + b[3]);
               
  println( xcoord(x-1) + "," + ycoord(y+1) + "=" + b[6] + " " 
         + x           + "," + ycoord(y+1) + "=" + b[5] + " " 
         + xcoord(x+1) + "," + ycoord(y+1) + "=" + b[4]);      
  println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  println("bits: " + join(nf(b,0),"")); 
  int neighborhood = rules.neighborhood_as_int(b);
  println("Current state: " + world[x][y]);
  rules.debug(world[x][y], b);  
  noLoop();
}
