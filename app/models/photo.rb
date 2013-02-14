class Photo < ActiveRecord::Base
  attr_accessible :caption, :image, :location

  belongs_to :collection
  delegate :owner, to: :collection, allow_nil: true

  extend FriendlyId
  friendly_id :caption, use: :slugged
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  acts_as_votable
  acts_as_commentable

  validates :caption, length: { maximum: 30 }


  def favourite_by(user)
    if collection.has_favourite_from_user? user
      collection.update_user_favourite user, self
    else
      collection.add_favourite_from_user user, self
    end
  end

  def unfavourite_by(user)
    collection.remove_favourite_for_user(user) if collection.favourite_of(user) == self
  end
end
