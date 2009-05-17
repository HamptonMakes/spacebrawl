require 'rubygems'
require 'sinatra'
require 'server/models/player'
require 'json'

set :reload, false

$players = {}

get("/players/new") do
  player = Player.new.save
  Marshal.dump(player)
end

get("/players/:id/action") do
  @player = Player.get params["id"]
  @player.send(params['do'], params)
  Marshal.dump("OK")
end

get("/universe") do
  Player.all.values.each do |p|
    p.move
  end
  
  Marshal.dump $players.values
end