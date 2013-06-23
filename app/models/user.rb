class User < ActiveRecord::Base

  has_secure_password

  extend FriendlyId
  friendly_id :nickname, use: :slugged

  acts_as_followable
  acts_as_follower
  acts_as_voter

  has_many :collections, dependent: :destroy
  has_many :photos, through: :collections, dependent: :destroy
  has_many :api_keys, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token
  after_create :create_access_token

  validates :first_name, presence: true, 
                         length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :nickname, presence: true, 
                       length: { maximum: 50 }, 
                       uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :email, presence: true, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }


  def name
    "#{first_name} #{last_name}"
  end

  def name=(new_name)
    self.first_name, self.last_name = new_name.split " ", 2
  end

  def public?
    privacy_level == "public"
  end

  def private?
    !public?
  end

  def generate_new_remember_token
    create_remember_token
    save!
  end

  def find_by_access_token(access_token)
    self.joins(:api_keys).where('api_keys.access_token = ? AND api_keys.expires_on > ?', access_token, Time.now).first
  end

  def current_access_token
    api_keys.most_recent_unexpired.pluck(:access_token).first
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def create_access_token
    api_keys.create
  end

end
