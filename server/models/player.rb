class Player
  attr :id

  def initialize
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @id = rand(1000000)
  end
  
  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.99
    @vel_y *= 0.99
  end
end