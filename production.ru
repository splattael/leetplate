require 'rubygems'
require 'sinatra'

disable :run, :reload, :logging

$LOAD_PATH.unshift "."

require 'app'

run Sinatra::Application
