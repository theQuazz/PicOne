class Photo < ActiveRecord::Base
  attr_accessible :caption, :image, :location

  before_save :generate_path

  belongs_to :collection
  belongs_to :user, through: :collection

  extend FriendlyId
  friendly_id :caption, use: :slugged
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates :caption, length: { maximum: 30 }
end
