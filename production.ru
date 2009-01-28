require 'rubygems'
require 'sinatra'

disable :run, :reload, :logging

require 'app'

run Sinatra::Application
