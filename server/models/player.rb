require 'dm-core'

class Player
  include DataMapper::Resource
  
  property :id, Integer, :serial => true 
  property :x, Float
  property :y, Float
  property :angle, Float
  property :vel_y, Float
  property :vel_x, Float

  def initialize
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @id = rand(1000000)
  end
  
  def warp(options = {})
    @x, @y = x, y
  end

  def turn_left(options = {})
    @angle -= 4.5
  end

  def turn_right(options = {})
    @angle += 4.5
  end
  
  # EASILY EXPLOITABLE!
  def velocity(variables)
    @vel_x = variables["vel_x"].to_f
    @vel_y = variables["vel_y"].to_f
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.99
    @vel_y *= 0.99
    self.save
  end
end

DataMapper.auto_upgrade!
