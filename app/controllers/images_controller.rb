class ImagesController < ApplicationController
  before_filter :set_image, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  respond_to :html, :json

  def index
    @images = current_user.images
    respond_to do |format|
      format.html
      format.json do
        current_user ? (@fb_albums = User.get_fb_albums(current_user)) : nil
        respond_with(@images, @fb_albums)
      end
    end
  end

  def show
    respond_with(@image)
  end

  def new
    @image = Image.new
    respond_with(@images)
  end

  def edit
  end

  def create
    @image = current_user.images.new(params[:image])
    @image.name ||= set_name(params[:image])
    @image.save
    respond_with(@image)
  end

  def update
    @image.update_attributes(params[:image])
    respond_with(@image)
  end

  def destroy
    @image.destroy
    respond_with(@image)
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def set_name(params)
      @image.name = (params['file'].original_filename || "uploaded image")
    end
end
