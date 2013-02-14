class Favourite < ActiveRecord::Base
  attr_accessible :collection, :user, :photo

  belongs_to :collection
  belongs_to :user
  belongs_to :photo

  validates :user_id, uniqueness: { scope: :collection_id } # this ensures user has only 1 favourite per collection
end
