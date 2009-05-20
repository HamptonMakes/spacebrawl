require 'sinatra'
set :run, false
set :environment, :production
require 'server'
run Sinatra::Application

