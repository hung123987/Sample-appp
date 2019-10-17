class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.constant

  attr_accessor :remember_token

  before_save{email.downcase!}

  validates :name, presence: true, length: {maximum: Settings.num50}
  validates :email, presence: true, length: {maximum: Settings.num255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.num6}
  validates :password, presence: true, length: {minimum: Settings.num6},
    allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update remember_digest: nil
  end
end
