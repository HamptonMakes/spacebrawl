

class Player
  attr :id, true
  
  def self.create
    get("players/new")
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
    
    velocity(:vel_x => @vel_x, :vel_y => @vel_y)
  end

  def draw(image)
    image.draw_rot(@x, @y, 1, @angle)
  end
  
  def method_missing(method, *args)
    options = args.last
    params = {:do => method}
    if options.is_a? Hash
      params.merge!(options)
    end
    uri_params = []
    uri_params = (params.collect do |key, value|
      "#{key}=#{value}"
    end).join("&")
    get("players/#{id}/action?do=#{method}")
  end
end