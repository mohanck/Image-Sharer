class Like < ApplicationRecord
  belongs_to :image
  belongs_to :user
  validates :image_id, presence: true, uniqueness: { value: :user_id, message: 'Like already exists' }
  validates :user_id, presence: true
  scope :exist?, -> (user_id, image_id) { where('user_id = ? and image_id = ?', user_id, image_id) }
end
