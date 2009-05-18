
class Ship < GameObject
  attr :health
  attr :last_fired
  
  def self.shape_array
    [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
  end
  
  def self.mass
    100.0
  end
  
  def self.inertia
    150.0
  end
  
  def perform_actions
    command = $cache.delete("player_#{@parent_id}")
    if command
      puts command + " #{@parent_id}"
      self.send(command)
    end
  end
  
  def warp(vect)
    @shape.body.p = vect
  end
  
  # Apply negative Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_left
    @shape.body.t -= 300.0
  end
  
  # Apply positive Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_right
    @shape.body.t += 300.0
  end
  
  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end
  
  def fire_missile
    if @last_fired.nil? || (@last_fired < ((Time.now) - 1))
      @last_fired = Time.now
      puts "FIRING!"
      Missile.new(self)
    end
  end
  
  # Apply reverse force
  # See accelerate for more details
  def reverse
    @shape.body.apply_force(-(@shape.body.a.radians_to_vec2 * (1000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
end
