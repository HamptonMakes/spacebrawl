require 'rubygems'
require 'httparty'

class SpaceBrawlServer
  include HTTParty
  base_uri '209.20.91.156'
  format :json

  def self.universe
    #start = Time.now
    result = get("/universe")
    #puts "took #{Time.now - start}"
    result
  end
  
  def self.action(player, action)
    start = Time.now
    result = get("/players/#{player.id}/action", :do => action)
    puts "took #{Time.now - start}"
    result
  end
  
  def self.new_player
    get("/players/new")
  end
end