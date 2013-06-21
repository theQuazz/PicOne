class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true

  before_create :generate_access_token, :set_expiration_date

  scope :unexpired, -> { where('expires_on > ?', Time.now) }
  scope :most_recent_unexpired, unexpired.order('expires_on DESC')

  def expired?
    expires_on < Time.now
  end

  def extend_expires_on!(by = 2.weeks)
    update_attributes expires_on: Time.now + by
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def set_expiration_date
    self.expires_on = Time.now + 2.weeks
  end

end
