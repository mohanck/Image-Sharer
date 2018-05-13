class ImagePolicy
  attr_reader :user, :image

  def initialize(user, image)
    @user = user
    @image = image
  end

  def edit?
    update?
  end

  def update?
    uploader?
  end

  def destroy?
    uploader?
  end

  private

  def uploader?
    @user == @image.user
  end
end
