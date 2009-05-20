require 'rubygems'
require 'gosu'
require 'models/player'
require 'models/game_object'
require 'open-uri'
require 'json'

class GameWindow < Gosu::Window
  def self.window_size
    [640, 480]
  end
  
  def initialize
    width, height = GameWindow.window_size
    super(width, height, false, 25)
    self.caption = "Space Brawl!"
    @player = Player.create

    GameObject.load_assets(self)

    @background_image = Gosu::Image.new(self, "images/background.png", true)
  end

  def update
    if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::Button::KbRight or button_down? Gosu::Button::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::GpButton0 then
      @player.accelerate
    end
    if button_down? Gosu::Button::KbSpace 
      @player.fire_missile
    end
    
    
    data = get("universe")

    objects = data["objects"].collect { |data| GameObject.new(data) }
    
    my_ship = (objects.select do |object|
      object.player_id.to_i == @player.id.to_i
    end).first
    
    my_ship.draw_health
    
    # only if my ship has shown up
    if my_ship
      offset_x, offset_y = my_ship.offsets
    
      objects.each do |object|
        object.draw offset_x, offset_y
      end
      @background_image.draw(-1 * (offset_x / 5) - 300, -1 * (offset_y / 5) - 200, 0)
    end
    
    
  end

  def draw
    #@background_image.draw(0, 0, 0);
  end

  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end
end

def get(path)
  JSON.load(open("http://209.20.91.156/#{path}"))
end

window = GameWindow.new
window.show