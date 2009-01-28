require 'rubygems'
require 'sinatra'

$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
require 'leetplate'

ResultCache = {} unless defined? ResultCache

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
  @prefix = params['prefix'].upcase

  dicts = ENV['DICT'] ? ENV['DICT'].split(/ /) :
    %w(/usr/share/dict/ngerman /usr/share/dict/american-english)

  unless @results = ResultCache[@prefix]
    finder = Leetplate::Finder.new(*dicts)
    @results = ResultCache[@prefix] = finder.find(params['prefix'])
  end
  haml :index
end

get '/style.css' do
  sass :style
end
