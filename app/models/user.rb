class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :nickname, 
                  :password, :password_confirmation, :email,
                  :birthday, :gender

  before_save { |user| user.email = email.downcase }

  has_many :collections
  has_many :photos, through: :collections

  extend FriendlyId
  friendly_id :name, use: :slugged
  has_secure_password
  acts_as_followable
  acts_as_follower

  validates :first_name, presence: true, 
                         length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :nickname, presence: true, 
                       length: { maximum: 50 }, 
                       uniqueness: {case_sensitive: false}
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :email, presence: true, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }


  def name
    "#{first_name} #{last_name}"
  end

  def name=(what)
    self.first_name, self.last_name = what.split " ", 2
  end
end
