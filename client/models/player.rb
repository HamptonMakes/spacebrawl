

class Player
  attr :id, true
  
  def initialize(data)
    @name = data["name"]
    @id = data["id"]
    @score = data["score"]
  end
  
  def self.create
    Player.new(SpaceBrawlServer.new_player)
  end
  
  def method_missing(method, *args)
    SpaceBrawlServer.action(self, method)
  end
end