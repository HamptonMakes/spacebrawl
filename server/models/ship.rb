
class Ship < GameObject
  attr :health
  attr :last_fired
  
  def initialize(parent = nil)
    super(parent)
    @health = 100
  end
  
  def self.shape_array
    [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
  end
  
  def self.mass
    100.0
  end
  
  def self.inertia
    60.0
  end
  
  # TODO: perform actions as actor
  def perform_actions
    new_objects = []
    while(command = $players[@parent_id][:actions].pop)
      if command
        puts command + " #{@parent_id}"
        new_object = self.send(command)
        if new_object
          new_objects << new_object
        end
      end
    end
    new_objects
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
  
  def hit!
    @health -= 5
    puts "HEALTH #{@health}"
  end
  
  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (20000.0)), CP::Vec2.new(0.0, 0.0))
  end
  
  def fire_missile
    if @last_fired.nil? || (@last_fired < ((Time.now) - 0.5))
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
