SUBSTEPS = 6

# Convenience method for converting from radians to a Vec2 vector.
class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

# Layering of sprites
module ZOrder
  Background, Stars, Player, UI = *0..3
end

class GameSpace
  attr :objects
  
  def initialize
    # Time increment over which to apply a physics "step" ("delta t")
    @dt = (1.0/60.0)
    
    # Create our Space and set its damping
    # A damping of 0.8 causes the ship bleed off its force and torque over time
    # This is not realistic behavior in a vacuum of space, but it gives the game
    # the feel I'd like in this situation
    @space = CP::Space.new
    @space.damping = 0.8
    
    @space.add_collision_func(:ship, :missile) do |ship_shape, missile_shape|
      missile = object_with_shape(missile_shape)
      if !missile.exploded
        ship = object_with_shape(ship_shape)
        ship.hit!
        missile.exploded = true
      end
    end
    
    # Cache that will get filled below
    @objects = []
  end
  
  def load_new_ships
    $players.keys.each do |player_id|
      if !(@objects.detect { |o| o.parent_id == player_id })
        add_game_object(Ship.new(player_id))
      end
    end
  end
  
  def add_game_object(game_object)
    @space.add_body(game_object.shape.body)
    @space.add_shape(game_object.shape)
    @objects << game_object
  end
  
  def remove_game_object(game_object)
    @objects.delete(game_object)
    @space.remove_body(game_object.shape.body)
    @space.remove_shape(game_object.shape)
  end
  
  def object_with_shape(shape)
    @objects.detect do |object|
      object.shape == shape
    end
  end
  
  def update
    load_new_ships

    @space.step(@dt)
  
    @objects.each do |object|
      results = object.perform_actions
      results.each do |result|
        if result.is_a? GameObject
          add_game_object result
        elsif result == false
          puts "REMOVING"
          remove_game_object(object)
        end
      end
    end
    
    
    first = true
    SUBSTEPS.times do
      @space.step(@dt)
      if first
        @objects.each do |object|
          object.shape.body.reset_forces
        end
        
        first = false
      end
    end
  end
  
  def to_a
    {:objects => (@objects.collect { |o| o.to_hash })}
  end
end