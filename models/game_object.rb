class GameObject
  attr :player_id
  attr :x
  attr :y
  
  def initialize(data)
    @x = data["x"]
    @y = data["y"]
    @angle = data["angle"]
    @player_id = data["parent_id"] || data["player_id"]
    @id = data["id"]
    @type = data["type"]
  end
  
  def self.load_assets(window)
    @@assets = {"ship" => Gosu::Image.new(window, "images/ship.png", false),
                "missile" => Gosu::Image.new(window, "images/missile.png", false)}
  end
  
  def offsets
    width, height = GameWindow.window_size
    [@x - (width / 2), @y - (height / 2)]
  end
  
  def draw(offset_x, offset_y)
    x = @x - offset_x
    y = @y - offset_y
    @@assets[@type].draw_rot(x, y, 1, @angle)
  end
end