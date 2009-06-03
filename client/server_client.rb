require 'rubygems'
require 'eventmachine'
require 'json'

module ServerClient
  @@action = nil
  @@connection = nil
  
  def post_init
    puts "client connected!"
    @@connection = self
    ServerClient.start_update_cycle
    ServerClient.action("accelerate")
  end
  
  def self.action(action)
    @@connection.send_datagram("#{$identity} #{action}", "0.0.0.0", 7779)
  end
  
  def self.start_update_cycle
    $game_objects.keys.each do |key|
      $game_objects[key][:tired] = true
    end
    ServerClient.action("update")
  end

  def receive_data(data)
    if data == "done"
      # clean the data of things we didn't get updates for
      $game_objects.keys.each do |key|
        if $game_objects[key][:tired]
          $game_objects.delete key
        end
      end
      
      #start the cycle again
      ServerClient.start_update_cycle
    else 
      
      # We are handling a torrent of updates right here
      update = JSON::load(data)
      $game_objects.merge!(update)
      p update.inspect
    end
  end
end