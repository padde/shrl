require 'rubygems'
require 'sinatra'
require './lib/shorturl'

get '/' do
  erb :index
end

post '/' do
  uri = URI::parse params[:url]
  unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS
    raise "Invalid URL"
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

error do
  @error = request.env['sinatra_error'].name
  haml :'500'
end