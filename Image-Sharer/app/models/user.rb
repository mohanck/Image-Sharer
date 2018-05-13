class User < ApplicationRecord
  has_many :images
  has_many :likes, through: :images
  before_save :downcase_email
  before_destroy :remove_likes
  validates :name, presence: { message: "Name can't be blank" },
                   length: { maximum: 30, message: 'Name is too long' }
  validates :email, presence: { message: "Email can't be blank" },
                    uniqueness: { case_sensitive: false, message: 'User already exists' },
                    length: { maximum: 254, message: 'Email is too long' }
  validates_email_format_of :email, message: 'Email is invalid'

  has_secure_password
  validates :password, presence: true, length: { minimum: 5, message: 'Password is too short' }
  # Presence validation is needed as 'has_secure_password' does not catch empty space passwords
  validates :password_confirmation, presence: { message: "Confirm Password can't be blank" }
  # Extra validation is needed as 'has_secure_password' does not validate password_confirmation if it is nil

  def liked?(image_id)
    !Like.exist?(id, image_id).blank?
  end

  private

  def downcase_email
    email.downcase!
  end

  def remove_likes
    Like.find_by(image_id: id).try(:destroy)
  end
end
