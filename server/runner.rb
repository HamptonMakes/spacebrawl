require 'init'
require 'Chipmunk-4.1.0/ruby/chipmunk'
require 'models/game_space'
gs = GameSpace.new

while(true)
  sleep(0.01)
  gs.update
  $cache["universe"] = JSON.dump(gs.to_a)
end
