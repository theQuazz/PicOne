class Collection < ActiveRecord::Base
  attr_accessible :name, :description

  belongs_to :owner, class_name: 'User'
  has_many :photos

  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_commentable

  validates :name, presence: true,
                   length: { maximum: 50 }
  validates :description, length: { maximum: 500 }


  def has_favourite_for_user?(user)
    Favourite.find_by_user_id_and_collection_id(user.id, self.id).present? rescue false
  end

  def favourite_of(user)
    Favourite.find_by_user_id_and_collection_id(user.id, self.id)
  end

  def remove_favourite_for_user(user)
    Favourite.find_by_user_id_and_collection_id(user.id, self.id).try(:destroy) rescue nil
  end

  def update_user_favourite(user, photo)
    favourite = Favourite.find_by_user_id_and_collection_id user.id, self.id
    return false unless favourite
    favourite.photo = photo
    favourite.save
  end

  def add_favourite_from_user(user, photo)
    favourite = Favourite.new({collection: self, user: user, photo: photo})
    favourite.save
  end
end
