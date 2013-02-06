class Photo < ActiveRecord::Base
  belongs_to :collection
  # attr_accessible :title, :body
end
