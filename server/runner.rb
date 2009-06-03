require 'init'
require 'chipmunk'
require 'models/game_space'
require 'models/player'
require 'eventmachine'
require 'json'
require 'socket'


Player.create(:name => "TEST")
$gs = GameSpace.new
$players = {}
$universe = nil

update = Proc.new do 
  start_time = Time.now
  $gs.update
  $universe = $gs.to_a
end

module DataServer
  def receive_data(data)
    p data
    player_id, action = data.split(" ")
    
    if $players[player_id].nil?
      $players[player_id] = {:actions => []}
    end
    
    if action != "update"
      $players[player_id][:actions] << action
    else
      $universe[:objects].each do |object|
        puts "sending object #{object[:id]}"
        send_data({object[:id] => object}.to_json)
      end
      send_data("done")
    end
  end
end

EM.run do
  EM.open_datagram_socket('0.0.0.0', 7779, DataServer)
  EM.add_periodic_timer(0.0166, update)
end



