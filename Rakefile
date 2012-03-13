require './lib/shorturl'

namespace :db do
  desc "migrate database"
  task :migrate do
    print 'migrating database... '
    require 'dm-migrations'
    DataMapper.auto_migrate!
    puts 'done.'
  end  
end