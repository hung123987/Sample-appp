class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.constant

  before_save{email.downcase!}

  validates :name, presence: true, length: {maximum: Settings.num50}
  validates :email, presence: true, length: {maximum: Settings.num255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.num6}

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
end
