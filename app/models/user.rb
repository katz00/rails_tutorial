class User < ApplicationRecord
  
  attr_accessor :remember_token, :activation_token, :reset_token #仮想の属性(仮想のカラム)

  before_save :downcase_email
  before_create :create_activation_digest

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

  #def authenticated?(remember_token)
  #  return false if remember_digest.nil?
  #  BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #end
  #上のコードをどのトークンにも対応できるように抽象化したのがしたのコード
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    #self.update_attribute(:activated, true)
    #self.update_attribute(:activated_at, Time.zone.now)
    #上二行のコードだとDBに二回アクセスしているが一回にできるそれが下
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest_to_users
    self.reset_token = User.new_token
    #self.update_attribute(:reset_digest, User.digest(reset_token))
    #self.update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token),
                    reset_sent_at: Time.zone.now)
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago #送信した時間が現時刻より2時間前
  end

  
  private
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
