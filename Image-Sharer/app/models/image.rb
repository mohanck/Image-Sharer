class Image < ApplicationRecord
  belongs_to :user
  has_many :likes, through: :user
  before_destroy :remove_likes
  validates :title, presence: { message: "Image Name can't be blank" }
  validates :url, presence: { message: "Image URL can't be blank" },
                  format: { with: %r{(http)s?(:)\/\/.[\S]+[.](png|jpeg|jpg|gif|tiff|bmp)},
                            message: 'Image URL is invalid' }
  validates :tag_list, presence: { message: 'Image needs to have at least one tag' },
                       length: { maximum: 50, message: 'Too many tags' }
  validate :maximum_tag_length
  acts_as_ordered_taggable

  def add_user_association(user_id)
    build_user(id: user_id)
  end

  private

  def maximum_tag_length
    tag_list.each do |tag|
      errors[:tag_list] << "Tag - #{tag} is longer than 30 characters" if tag.length > 30
    end
  end

  def remove_likes
    Like.find_by(image_id: id).try(:destroy)
  end
end
