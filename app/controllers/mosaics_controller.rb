class MosaicsController < ApplicationController
  before_filter :set_mosaic, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

  respond_to :html, :json

  def index
    @mosaics = current_user.mosaics
    respond_with(@mosaics)
  end

  def show
    respond_with(@mosaic)
  end

  def new
    @images = current_user.images
    @mosaic = Mosaic.new
    respond_with(@mosaic)
  end

  def edit
  end

  def create
    @mosaic = current_user.mosaics.new(params[:mosaic])
    @mosaic.save
    paths = MosaicMaker.create_new(@mosaic)
    @mosaic.update_attributes(path: paths[0], path_small: paths[1] )
    current_user.images.delete_all
    respond_with(@mosaic)
  end

  def update
    @mosaic.update_attributes(params[:mosaic])
    respond_with(@mosaic)
  end

  def destroy
    @mosaic.destroy
    respond_with(@mosaic)
  end

  private
  def set_mosaic
    @mosaic = Mosaic.find(params[:id])
  end
end
