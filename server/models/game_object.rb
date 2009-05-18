# Override move to implement

class GameObject
  attr :parent_id, true
  attr :shape, true
  attr :pending_action, true

  def initialize(parent_id = nil)
    @health = 0
    @parent_id = parent_id if parent_id
    @id = rand(100000)
    @shape = make_shape
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
  end
  
  def perform_actions
  end
  
  def make_shape
    # Create the Body for the Player
    body = CP::Body.new(self.class.mass, self.class.inertia)
    
    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use s simple, 4 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    @shape = CP::Shape::Poly.new(body, self.class.shape_array, CP::Vec2.new(0,0))
    
    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    shape.collision_type = type
    shape
  end
  
  def type
    self.class.to_s.downcase.to_sym
  end
  
  def key
    "#{type}_#{id}"
  end
  
  def to_hash
    {:x => @shape.body.p.x, :y => @shape.body.p.y, :angle => @shape.body.a.radians_to_gosu, :type => type, :id => @id, :parent_id => @parent_id}
  end
end