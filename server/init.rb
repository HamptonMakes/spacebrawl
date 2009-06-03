require 'rubygems'
require 'models/player'
require 'models/game_object'
require 'models/ship'
require 'models/missile'
require 'json'

module Math
  def self.offset_x(angle, distance)
    Math.cos(angle) * distance
  end
  
  def self.offset_y(angle, distance)
    Math.sin(angle) * distance
  end
end
