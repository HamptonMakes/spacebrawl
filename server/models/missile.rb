class Missile < GameObject
  attr :exploded, true
  
  def initialize(ship = nil)
    super(ship.parent_id)
    @exploded = false
    @shape.body.a = ship.shape.body.a
    x = ship.shape.body.p.x + Math::offset_x(@shape.body.a, 40)
    y = ship.shape.body.p.y + Math::offset_y(@shape.body.a, 40)
    @shape.body.p = CP::Vec2.new(x, y)
    
    @kill_at = Time.now + 1
    
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (20000.0)), CP::Vec2.new(0.0, 0.0))
  end
  
  def perform_actions
    if @kill_at < Time.now
      false
    else
      true
    end
  end

  def self.shape_array
    [CP::Vec2.new(-15.0, -2.5), CP::Vec2.new(15.0, -5.0), CP::Vec2.new(15.0, 5.0), CP::Vec2.new(-15.0, 2.5)]
  end
  
  def self.mass
    3.0
  end
  
  def self.inertia
    1.0
  end
end

