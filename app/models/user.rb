class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{:email_downcase}

  validates :name, presence: true,
    length: {maximum: Settings.length.name}

  validates :email, presence: true,
    length: {maximum: Settings.length.email},
    format: {with: Settings.regex.email_regex},
    uniqueness: true

  has_secure_password
  validates :password, length: {minimum: Settings.length.password}
  validate :valid_birthday, if: ->{birthday.present?}

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  private

  def valid_birthday
    return if Date.parse(birthday) > Settings.length.birthday.years.ago

    errors.add(:birthday, I18n.t("error.valid"))
  end

  def email_downcase
    email.downcase!
  end
end
