class User < ApplicationRecord
  
  attr_accessor :remember_token #仮想の属性(仮想のカラム)

  before_save { email.downcase! }

  validates :name, presence: true
  validates :name, length: {maximum: 50}

  validates :email, presence: true
  validates :email, length:{ maximum: 255}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :email, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length:{ minimum: 6}, allow_nil: true #ユーザー更新の時限定でnilでも引っかからない
  validates :password, presence: true, allow_nil: true #ユーザー更新の時限定でnilでも引っかからない

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    self.update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
