require 'rubygems'
require 'sinatra'
require 'models/player'
require 'json'

set :reload, false

$players = {}

get("/players/new") do
  player = Player.new
  $players[player.id] = player
  Marshal.dump(player)
end

get("/players/:id/action") do
  @player = $players[params["id"].to_i]
  @player.send(params['do'])
  Marshal.dump("OK")
end

get("/universe") do
  $players.values.each do |p|
    p.move
  end
  
  Marshal.dump $players.values
end