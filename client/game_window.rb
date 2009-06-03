require 'rubygems'
require 'gosu'
require 'models/player'
require 'models/game_object'

class GameWindow < Gosu::Window
  def self.window_size
    [640, 480]
  end
  
  def initialize
    width, height = GameWindow.window_size
    super(width, height, false, 25)
    self.caption = "Space Brawl!"

    GameObject.load_assets(self)

    @background_image = Gosu::Image.new(self, "images/background.png", true)
  end

  def update
    if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::GpLeft then
      ServerClient.action "turn_left"
    end
    if button_down? Gosu::Button::KbRight or button_down? Gosu::Button::GpRight then
      ServerClient.action "turn_right"
    end
    if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::GpButton0 then
      ServerClient.action "accelerate"
    end
    if button_down? Gosu::Button::KbSpace 
      ServerClient.action "fire_missile"
    end
    
    if $game_objects.any?
      objects = $game_objects.values.collect { |data| GameObject.new(data) }
    
      my_ship = objects.detect do |object|
        object.parent_id == $identity && object.image == "ship"
      end
      
      offset_x, offset_y = 0, 0
    
      # only if my ship has shown up
      if my_ship
        my_ship.draw_health
        offset_x, offset_y = my_ship.offsets
      end
        
      
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
      EM.stop
      close
    end
  end
end