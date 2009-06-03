

class Player
  attr :id, true
  
  def initialize(data = {})
    @name = data["name"]
    @id = data["id"]
    @score = data["score"]
  end
  
  def self.create(identity)
    # Implement
    Player.new("id" => identity)
  end
  
  def method_missing(method, *args)
    SpaceBrawlServer.action(self, method)
  end
end