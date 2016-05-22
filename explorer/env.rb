require 'rubygems'
require 'bundler'

APP_ROOT = ENV['APP_ROOT'] ||= File.expand_path('..', __FILE__)

Encoding.default_external = 'utf-8'

Bundler.setup
Bundler.require

require 'dotenv'
Dotenv.load

$LOAD_PATH.unshift File.join(APP_ROOT, 'lib')

autoload :Track, 'track'
autoload :User, 'user'
autoload :Like, 'like'

Dir[APP_ROOT + '/initializers/**/*.rb'].each do |file|
  require file
end
