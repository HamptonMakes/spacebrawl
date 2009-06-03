require 'rubygems'
require 'gosu'
require 'game_window'
require 'server_client'

$game_objects = {}
$identity = "me"

Thread.abort_on_exception = true

gui_window = Proc.new do
  window = GameWindow.new
  window.show
end

EventMachine::run do
  EventMachine::open_datagram_socket('0.0.0.0', rand(1000) + 7000, ServerClient)
  EventMachine::defer gui_window, Proc.new { exit }
end