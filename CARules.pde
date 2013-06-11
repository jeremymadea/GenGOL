
  
class CARules 
{
  static final int SYMMETRY_NONE = 0; 
  static final int SYMMETRY_MIRROR_PLUS_8_WAY = 1; 
  static final int SYMMETRY_MIRROR_PLUS_4_WAY = 2;
    
  int mirror_plus_4_way[] = {
     0,  1,  2,  3,  1,  4,  3,  5,  2,  6,  7,  8,  3,  9, 10, 11,
     1, 12,  6, 13,  4, 14,  9, 15,  3, 13,  8, 16,  5, 15, 11, 17,
     2,  6, 18, 19,  6, 20, 19, 21,  7, 22, 23, 24,  8, 25, 26, 27,
     3, 13, 19, 28,  9, 29, 30, 31, 10, 32, 26, 33, 11, 34, 35, 36,
     1,  4,  6,  9, 12, 14, 13, 15,  6, 20, 22, 25, 13, 29, 32, 34,
     4, 14, 20, 29, 14, 37, 29, 38,  9, 29, 25, 39, 15, 38, 34, 40,
     3,  9, 19, 30, 13, 29, 28, 31,  8, 25, 24, 41, 16, 39, 33, 42,
     5, 15, 21, 31, 15, 38, 31, 43, 11, 34, 27, 42, 17, 40, 36, 44,
     2,  3,  7, 10,  6,  9,  8, 11, 18, 19, 23, 26, 19, 30, 26, 35,
     6, 13, 22, 32, 20, 29, 25, 34, 19, 28, 24, 33, 21, 31, 27, 36,
     7,  8, 23, 26, 22, 25, 24, 27, 23, 24, 45, 46, 24, 41, 46, 47,
     8, 16, 24, 33, 25, 39, 41, 42, 26, 33, 46, 48, 27, 42, 47, 49,
     3,  5,  8, 11, 13, 15, 16, 17, 19, 21, 24, 27, 28, 31, 33, 36,
     9, 15, 25, 34, 29, 38, 39, 40, 30, 31, 41, 42, 31, 43, 42, 44,
    10, 11, 26, 35, 32, 34, 33, 36, 26, 27, 46, 47, 33, 42, 48, 49,
    11, 17, 27, 36, 34, 40, 42, 44, 35, 36, 47, 49, 36, 44, 49, 50     
  }; 
  
  int mirror_plus_8_way[] = {
    0,  1,  1,  2,  1,  3,  2,  4,  1,  5,  3,  6,  2,  6,  4,  7,  
    1,  8,  5,  9,  3, 10,  6, 11,  2,  9,  6, 12,  4, 11,  7, 13,  
    1,  5,  8,  9,  5, 14,  9, 15,  3, 14, 10, 16,  6, 17, 11, 18,  
    2,  9,  9, 19,  6, 16, 12, 20,  4, 15, 11, 20,  7, 18, 13, 21,  
    1,  3,  5,  6,  8, 10,  9, 11,  5, 14, 14, 17,  9, 16, 15, 18,  
    3, 10, 14, 16, 10, 22, 16, 23,  6, 16, 17, 24, 11, 23, 18, 25,  
    2,  6,  9, 12,  9, 16, 19, 20,  6, 17, 16, 24, 12, 24, 20, 26,  
    4, 11, 15, 20, 11, 23, 20, 27,  7, 18, 18, 26, 13, 25, 21, 28,  
    1,  2,  3,  4,  5,  6,  6,  7,  8,  9, 10, 11,  9, 12, 11, 13,  
    5,  9, 14, 15, 14, 16, 17, 18,  9, 19, 16, 20, 15, 20, 18, 21,  
    3,  6, 10, 11, 14, 17, 16, 18, 10, 16, 22, 23, 16, 24, 23, 25,  
    6, 12, 16, 20, 17, 24, 24, 26, 11, 20, 23, 27, 18, 26, 25, 28,  
    2,  4,  6,  7,  9, 11, 12, 13,  9, 15, 16, 18, 19, 20, 20, 21,  
    6, 11, 17, 18, 16, 23, 24, 25, 12, 20, 24, 26, 20, 27, 26, 28,  
    4,  7, 11, 13, 15, 18, 20, 21, 11, 18, 23, 25, 20, 26, 27, 28,  
    7, 13, 18, 21, 18, 25, 26, 28, 13, 21, 25, 28, 21, 28, 28, 29     
  };  
  
  int number_of_rules; 
  int symmetry_lookup[];
  int symmetry_family; 
  int rule_set_a[] = new int[256]; 
  int rule_set_b[] = new int[256]; 
  int compiled_rules_a[] = new int[256]; 
  int compiled_rules_b[] = new int[256]; 
  
  CARules(int family) {
   set_symmetry(family); 
  }

  void set_symmetry(int family) 
  {
    symmetry_family = family; 
    switch (family) { 
      case SYMMETRY_NONE:
        symmetry_lookup = new int[256]; 
        for (int i=0; i<256; i++) {
          symmetry_lookup[i] = i; 
        } 
        println("Symmetry set to NONE.");
        break; 
      case SYMMETRY_MIRROR_PLUS_8_WAY:
        symmetry_lookup = mirror_plus_8_way;
        println("Symmetry set to MIRROR PLUS 8 WAY"); 
        break; 
      case SYMMETRY_MIRROR_PLUS_4_WAY:
        symmetry_lookup = mirror_plus_4_way; 
        println("Symmetry set to MIRROR PLUS 4 WAY");  
        break; 
    }
    number_of_rules = symmetry_lookup[255] + 1; // The last lookup translation is always the index of the last rule. 
  }
  
  void compile_rules() 
  {
    for (int i=0; i<256; i++) { 
      compiled_rules_a[i] = rule_set_a[ symmetry_lookup[i] ]; 
      compiled_rules_b[i] = rule_set_b[ symmetry_lookup[i] ];
    } 
  }
  
  void print_rule_set() 
  {
    println( "{\"" + join(nf(rule_set_a, 0), "").substring(0, number_of_rules) + "\",");
    println( "\""  + join(nf(rule_set_b, 0), "").substring(0, number_of_rules) + "\"}");
  }
  
  void load_rules(String rules[]) 
  { 
    if (rules[0].length() != number_of_rules) {
      if (rules[0].length() == 256) {
        set_symmetry(CARules.SYMMETRY_NONE); 
      } else if (rules[0].length() == mirror_plus_4_way[255] + 1) {
        set_symmetry(CARules.SYMMETRY_MIRROR_PLUS_4_WAY); 
      } else if (rules[0].length() == mirror_plus_8_way[255] + 1) {
        set_symmetry(CARules.SYMMETRY_MIRROR_PLUS_8_WAY);   
      } else { 
        println("Error: Cannot load rule set. Wrong number of rules provided for the currently defined symmetries.");
        return; 
      }
    }
    for (int i=0; i < rules[0].length(); i++) {
      rule_set_a[i] = rules[0].charAt(i) == '0' ? 0 : 1;  
      rule_set_b[i] = rules[1].charAt(i) == '0' ? 0 : 1;  
    }
    compile_rules(); 
    print_rule_set();    
  }
  
  void randomize(int rule_density) 
  { 
    for (int i=0; i<256; i++) { 
      rule_set_a[i] = ( rule_density > random(100) ? 1 : 0 );
      rule_set_b[i] = ( rule_density > random(100) ? 1 : 0 );
    }
    compile_rules(); 
    print_rule_set();  
  }
  
  void randomize_asymmetrically(int rule_density) 
  { 
    for (int i=0; i<256; i++) { 
      rule_set_a[i] = ( rule_density > random(100) ? 1 : 0 );
      rule_set_b[i] = ( rule_density < random(100) ? 1 : 0 );
    }
    compile_rules(); 
    print_rule_set();  
  }  
  
  void invert() 
  {
    int tmp_rule_set[] = rule_set_a; 
    rule_set_a = rule_set_b; 
    rule_set_b = tmp_rule_set; 
  }
  
  int neighborhood_as_int(int neighborhood[]) 
  {
    int n = 0; 
    for (int i=7; i>=0; i--) {
      n <<= 1; 
      n |= neighborhood[i]; 
    }
    return n; 
  }
  
  int apply(int current_state, int thehood[])
  {
    if (current_state == 0) { 
      return compiled_rules_a[neighborhood_as_int(thehood)]; 
    } else {
      return compiled_rules_b[neighborhood_as_int(thehood)]; 
    } 
  }
  
  void debug(int current_state, int thehood[])
  {
      int neighborhood = neighborhood_as_int(thehood);
      println("Neighborhood #" + neighborhood 
        + " -> Rule #" + symmetry_lookup[neighborhood] 
        + " -> Next state: " + rules.apply(current_state, thehood));
  }
  
  void mutate(float mutation_rate) 
  {
    for (int i=0; i<number_of_rules; i++) {
      if (random(1) < mutation_rate) {
        rule_set_a[i] = rule_set_a[i] ^ 1;
        println("Mutation in rule_set_a at site: " + i);
      }  
      if (random(1) < mutation_rate) {
        rule_set_b[i] = rule_set_b[i] ^ 1;
        println("Mutation in rule_set_b at site: " + i); 
      }  
    }
  }
  
  CARules spawn() 
  {
    CARules new_rules;
    String[] rule_strings = new String[2];
    String a = join(nf(rule_set_a, 0), "").substring(0, number_of_rules); 
    String b = join(nf(rule_set_b, 0), "").substring(0, number_of_rules);
    int crossover_a = int(random(a.length()));
    int crossover_b = int(random(b.length()));
    println("Crossover A: " + crossover_a); 
    println("Crossover B: " + crossover_b); 
    print_rule_set();
    rule_strings[0] = a.substring(crossover_a, a.length()) + a.substring(0, crossover_a);
    rule_strings[1] = b.substring(crossover_b, b.length()) + b.substring(0, crossover_b);
    new_rules = new CARules(symmetry_family);
    new_rules.load_rules(rule_strings);
    new_rules.mutate(.005);    
    new_rules.print_rule_set();
    return new_rules; 
  }
  
  
}
