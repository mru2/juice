require 'meta_field'

class Track < ActiveRecord::Base
  include MetaField

  has_many :likes
  has_many :users, class_name: 'User', through: :likes
end
