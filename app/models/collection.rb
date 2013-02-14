class Collection < ActiveRecord::Base
  attr_accessible :name, :description

  belongs_to :user
  has_many :photos

  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_commentable

  validates :name, presence: true,
                   length: { maximum: 50 },
  validates :description, length: { maximum: 500 }
end
