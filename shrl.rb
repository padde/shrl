require 'rubygems'
require 'sinatra'
require './lib/shorturl'

class InvalidProtocolError < StandardError; end

get '/' do
  erb :index
end

get '/list' do
  @shorturls = ShortURL.all
  erb :list
end

post '/' do
  unless params[:url] =~ /[a-zA-Z]+:\/\/.*/
    params[:url] = "http://#{params[:url]}"
  end
  
  uri = URI::parse(params[:url])
  unless uri.kind_of?(URI::HTTP) || uri.kind_of?( URI::HTTPS)
    raise InvalidProtocolError
  end
  
  @shorturl = ShortURL.first_or_create( destination: uri.to_s )
  @url = @shorturl.destination
  
  erb :index
end

get '/:shortcode' do
  id = ShortURL.shortcode_to_id(params[:shortcode])
  @shorturl = ShortURL.get(id)
  
  unless @shorturl.nil?
    @shorturl.update( clicks: @shorturl.clicks + 1 )
    redirect @shorturl.destination
  else
    raise Sinatra::NotFound
  end
end

not_found do
  @url = params[:url]
  @error = 'Page not found.'
  erb :index
end

error URI::InvalidURIError do
  @url = params[:url]
  @error = 'Sorry, this is an invalid URL.'
  erb :index
end

error InvalidProtocolError do
  @url = params[:url]
  @error = 'Sorry, only HTTP and HTTPS are supported.'
  erb :index
end

error do
  @url = params[:url]
  
  if env['sinatra.error'].respond_to? :name
    @error = env['sinatra.error'].name
  else
    @error = env['sinatra.error']
  end
  
  erb :index
end
