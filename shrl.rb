require 'rubygems'
require 'sinatra'
require './lib/shorturl'

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
  
  uri = URI::parse params[:url]
  unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS
    raise InvalidProtocolError
  end
  
  @shorturl = ShortURL.first_or_create( destination: uri.to_s )
  
  erb :index
end

get '/:shortcode' do
  id = ShortURL.shortcode_to_id(params[:shortcode])
  @shorturl = ShortURL.get(id)
  
  unless @shorturl.nil?
    redirect @shorturl.destination
    @shorturl.update( clicks: @shorturl.clicks + 1 )
  else
    raise Sinatra::NotFound
  end
end

not_found do
  erb :'404'
end

error URI::InvalidURIError do
  @error = 'Sorry, this is an invalid URL.'
  erb :'500'
end

error InvalidProtocolError do
  @error = 'Sorry, only HTTP and HTTPS are supported.'
  erb :'500'
end

error do
  if env['sinatra.error'].respond_to? :name
    @error = env['sinatra.error'].name
  else
    @error = env['sinatra.error']
  end
  
  erb :'500'
end

class InvalidProtocolError < Error; end