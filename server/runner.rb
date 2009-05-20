require 'init'
require 'chipmunk'
require 'models/game_space'
gs = GameSpace.new

while(true)
  sleep(0.01)
  gs.update
  $cache["universe"] = JSON.dump(gs.to_a)
end
