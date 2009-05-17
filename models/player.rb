

class Player
  attr :id, true
  
  def self.create
    get("players/new")
  end

  def draw(image)
    image.draw_rot(@x, @y, 1, @angle)
  end
  
  def method_missing(method, *args)
    get("players/#{id}/action?do=#{method}")
  end
end