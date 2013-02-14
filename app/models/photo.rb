class Photo < ActiveRecord::Base
  attr_accessible :caption, :path, :location

  before_save :generate_path

  belongs_to :collection
  belongs_to :user, through: :collection

  extend FriendlyId
  friendly_id :caption, use: :slugged

  validates :caption, length: { maximum: 30 }


  def generate_path
    # this is just a preliminary implementation
    self.path = File.join Rails.root, 'public', to_param
  end
end
