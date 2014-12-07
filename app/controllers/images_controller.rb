class ImagesController < ApplicationController
  before_filter :set_image, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

  respond_to :html

  def index
    @images = Image.all
    respond_with(@images)
  end

  def show
    respond_with(@image)
  end

  def new
    @image = Image.new
    respond_with(@image)
  end

  def edit
  end

  def create
    @image = current_user.images.new(params[:image])
    # debugger
    @image.name = set_name(params[:image])
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
      @image.name.length > 0 ? @image.name : params['file'].original_filename
    end
end
