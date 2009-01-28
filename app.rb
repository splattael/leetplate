require 'rubygems'
require 'sinatra'

$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
require 'leetplate'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  haml :index
end

get '/search' do
  redirect '/'
end

post '/search' do
  if /^[a-zA-Z]{1,3}$/ !~ params['prefix']
    return redirect('/')
  end
  @prefix = params['prefix']

  dicts = ENV['DICT'] ? ENV['DICT'].split(/ /) :
    %w(/usr/share/dict/ngerman /usr/share/dict/american-english)
  finder = Leetplate::Finder.new(*dicts)
  @results = finder.find(params['prefix'])
  haml :index
end

get '/style.css' do
  sass :style
end
