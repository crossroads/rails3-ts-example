class Document < ActiveRecord::Base
  attr_accessible :title, :country_ids, :image_ids, :subscriber_ids, :tag_ids, :video_ids

  has_and_belongs_to_many :countries
  has_and_belongs_to_many :images
  has_and_belongs_to_many :subscribers
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :videos
end
