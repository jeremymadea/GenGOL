class CADemo
{
  static final int INIT_WORLD_RANDOM = 0; 
  static final int INIT_WORLD_RANDOM_BLOCK = 1; 
  static final int INIT_WORLD_SINGLE_CELL = 2; 
  String[] rules = new String[2];
  int population_density; 
  int skip_iters;
  int init_type; 
  String comment;  
    
  CADemo(JSONObject json) 
  {  
    rules[0] = json.getString("A"); 
    rules[1] = json.getString("B"); 
      println(json); 
    population_density = json.getInt("pd");
    skip_iters = json.getInt("skip");
    init_type = json.getInt("init"); 
    comment = json.getString("comment");
 
  }
  
  JSONObject asJSON() 
  {
    JSONObject json = new JSONObject(); 
    json.setString("A", rules[0]); 
    json.setString("B", rules[1]);
    json.setInt("pd", population_density); 
    json.setInt("skip", skip_iters); 
    json.setInt("init", init_type); 
    return json; 
  }
  
}
