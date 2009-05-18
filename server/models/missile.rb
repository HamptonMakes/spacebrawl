class Missile < GameObject
  
  def initialize(ship = nil)
    super(ship.parent_id)
    @shape.body.a = ship.shape.body.a
    x = ship.shape.body.p.x + Gosu::offset_x(@shape.body.a.radians_to_gosu, 100)
    y = ship.shape.body.p.y + Gosu::offset_y(@shape.body.a.radians_to_gosu, 100)
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
    5.0
  end
  
  def self.inertia
    1.0
  end
end

