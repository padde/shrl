require 'dotenv'
Dotenv.load

require './lib/shorturl'

namespace :db do
  desc "migrate database"
  task :migrate do
    print 'migrating database... '
    require 'dm-migrations'
    DataMapper.auto_upgrade!
    puts 'done.'
  end  
end

namespace :server do
  desc "start server"
  task :start do
    system "shotgun"
  end
end