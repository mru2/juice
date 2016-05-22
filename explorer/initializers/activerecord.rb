require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL'))
