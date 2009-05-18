

class Player
  attr :id, true
  
  def initialize(data)
    @name = data["name"]
    @id = data["id"]
    @score = data["score"]
  end
  
  def self.create
    Player.new(get("players/new"))
  end
  
  def method_missing(method, *args)
    params = {:do => method}
    if args.last.is_a? Hash
      params.merge!(args.last)
    end

    uri_params = (params.collect do |key, value|
      "#{key}=#{value}"
    end).join("&")
    
    get("players/#{id}/action?#{uri_params}")
  end
end