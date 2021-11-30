class User < ApplicationRecord
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

  private

  def valid_birthday
    return if Date.parse(birthday) > Settings.length.birthday.years.ago

    errors.add(:birthday, I18n.t("error.valid"))
  end

  def email_downcase
    email.downcase!
  end
end
