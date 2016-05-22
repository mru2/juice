require 'meta_field'

class User < ActiveRecord::Base
  include MetaField

  has_many :likes
  has_many :tracks, class_name: 'Track', through: :likes

  def self.named(username)
    find_by_display(username)
  end
end
