class User < ApplicationRecord

  before_save { email.downcase! }

  validates :name, presence: true
  validates :name, length: {maximum: 50}

  validates :email, presence: true
  validates :email, length:{ maximum: 255}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :email, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length:{ minimum: 6}
  validates :password, presence: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
