require 'server/init'
require 'server/Chipmunk-4.1.0/ruby/chipmunk'
require 'server/models/game_space'
gs = GameSpace.new

while(true)
  sleep(0.01)
  gs.update
  $cache["universe"] = JSON.dump(gs.to_a)
end