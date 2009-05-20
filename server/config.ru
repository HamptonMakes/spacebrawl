require 'sinatra'
set :run, false
set :environment, :production

set :logging, true
 
require 'server'
run Sinatra::Application

