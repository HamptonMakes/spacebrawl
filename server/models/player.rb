require 'dm-core'

DataMapper.setup(:default, 'mysql://root@localhost/spacebrawl')
DataMapper::Logger.new(STDOUT, :debug)

class Player
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :name, String
  property :score, Integer, :default => 0
  property :ship_id, Integer
  
  def to_hash
    {:id => @id, :score => @score, :name => @name}
  end
  
end

DataMapper.auto_upgrade!
