require 'rubygems'
require 'server/models/player'
require 'server/models/game_object'
require 'server/models/ship'
require 'server/models/missile'
require 'json'
require 'server/moneta/lib/moneta'
require 'server/moneta/lib/moneta/memcache'

module Math
  def self.offset_x(angle, distance)
    Math.cos(angle) * distance
  end
  
  def self.offset_y(angle, distance)
    Math.sin(angle) * distance
  end
end

$cache = Moneta::Memcache.new(:server => "localhost")