require 'rubygems'
require 'server/models/player'
require 'server/models/game_object'
require 'server/models/ship'
require 'server/models/missile'
require 'json'
require 'server/moneta/lib/moneta'
require 'server/moneta/lib/moneta/memcache'
require 'gosu'

$cache = Moneta::Memcache.new(:server => "localhost")