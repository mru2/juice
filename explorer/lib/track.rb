class Track < ActiveRecord::Base
  has_many :likes
  has_many :users, class_name: 'User', through: :likes
end
