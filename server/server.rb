require 'server/init'
require 'sinatra'

set :reload, false

def serialize(data)
  JSON.dump(data)
end

def report_status(text)
  serialize({:status => text})
end

get("/players/new") do
  player = Player.create(:name => "Crazyhorse")
  serialize player.to_hash
end

get("/players/:id/action") do
  player = Player.get params["id"]
  $cache["player_#{player.id}"] = params['do']
  report_status "OK"
end

get("/universe") do
  $cache.fetch("universe", JSON.dump([]))
end