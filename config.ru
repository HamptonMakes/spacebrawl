require 'sinatra'
set :run, false
set :environment, :production
require 'server/server'
run Sinatra::Application

