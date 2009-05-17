require 'rubygems'
require 'gosu'
require 'models/player'
require 'open-uri'
require 'json'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Space Brawl!"
    @player = Player.create
    
    @image = Gosu::Image.new(self, "images/ship.png", false)
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
    
    get("universe").each do |player|
      player.draw @image
    end
  end

  def draw
    @background_image.draw(0, 0, 0);
  end

  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end
end

def get(path)
  Marshal.load(open("http://localhost:4567/#{path}"))
end

window = GameWindow.new
window.show