require 'dm-core'
require 'dm-timestamps'

ENV['DATABASE_URL'] ||= "sqlite://#{File.expand_path(File.dirname(__FILE__)+'/..')}/db/development.db"
DataMapper.setup(:default, ENV['DATABASE_URL'])

class ShortURL
  include DataMapper::Resource
  
  property :id, Serial
  property :destination, String, length: 2000, required: true
  property :created_at, DateTime, required: true
  property :clicks, Integer, default: 0
  
  def shortcode
    self.id.to_s(36)
  end
  
  def self.shortcode_to_id shortcode
    shortcode.to_i(36)
  end
end

DataMapper.finalize