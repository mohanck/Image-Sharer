class ImagesController < ApplicationController
  before_action :user_authenticated?, except: [:index, :show]

  def index
    if params.key?(:tag)
      display_tagged_images
    else
      @images = Image.order(created_at: :desc)
    end
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_permit_params)
    @image.add_user_association(session[:user_id])
    if !@image.save
      render :new, status: :unprocessable_entity
    else
      flash[:success] = 'Image uploaded successfully'
      redirect_to @image
    end
  end

  def show
    check_image_exists('view')
  end

  def edit
    check_image_exists('edit')
    authorize(@image)
  end

  def update
    @image = Image.find(params[:id])
    authorize(@image)
    if @image.update_attributes(image_edit_permit_params)
      redirect_to @image, flash: { success: 'Image Attributes changed successfully' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    check_image_exists('delete')
    return unless @image.present?
    authorize(@image)
    @image.destroy!
    flash[:success] = 'You have successfully deleted the image'
    redirect_to root_path
  end

  def share
    check_image_exists('share')
    return unless @image.present?
    @share_form = ShareForm.new
    render partial: 'modals/form_modal'
  end

  def send_email
    check_image_exists('share')
    return unless @image.present?
    @share_form = ShareForm.new(share_form_permit_params)
    if @share_form.valid?
      @email = params[:share_form][:email]
      @message = params[:share_form][:message]
      prepare_mail
    else
      respond_to do |format|
        format.json do
          render partial: 'modals/form_modal.html.erb', status: :unprocessable_entity
        end
      end
    end
  end

  private

  def image_permit_params
    params.require(:image).permit(:title, :url, :tag_list)
  end

  def share_form_permit_params
    params.require(:share_form).permit(:email, :message)
  end

  def image_edit_permit_params
    params.require(:image).permit(:title, :tag_list)
  end

  def display_tagged_images
    if params[:tag].present?
      display_tag_present_message
    else
      flash.now[:danger] = 'Tag cannot be empty'
    end
  end

  def display_tag_present_message
    if Image.tagged_with(params[:tag]).present?
      @images = Image.tagged_with(params[:tag]).order(created_at: :desc)
    else
      flash.now[:danger] = "No images exist with tag - #{params[:tag]}"
    end
  end

  def prepare_mail
    begin
      image = Image.find(params[:id])
      @mail = ImageMailer.share_image(@email, @message, image.url)
        .deliver_now
      add_flash_message
    rescue ActiveRecord::RecordNotFound
      flash.now[:danger] = 'Oops.. Image you are trying to share does not exist'
      return render json: { flash: { danger: flash.now[:danger] }, url: root_url }, status: :not_found
    end
    render json: { flash: { success: flash.now[:success] }, url: root_url }
  end

  def add_flash_message
    if @mail.blank?
      flash.now[:danger] = 'Image could not be shared'
    else
      flash.now[:success] = "Image shared with #{params[:share_form][:email]}"
    end
  end

  def check_image_exists(message)
    @image = Image.find_by(id: params[:id])
    if @image.blank?
      error_message = "Oops.. Image you are trying to #{message} does not exist"
      respond_to do |format|
        format.json do
          flash.now[:danger] = error_message
          return render json: { flash: { danger: flash.now[:danger] } }, status: :not_found
        end
        format.html do
          flash[:danger] = error_message
          return redirect_to root_url, status: :not_found
        end
      end
    end
  end

  def user_authenticated?
    unless logged_in?
      session[:redirect_url] = request.original_url
      redirect_to new_session_path, flash: { warning: 'You need to login' }
    end
  end
end
