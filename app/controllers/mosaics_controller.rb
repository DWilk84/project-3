class MosaicsController < ApplicationController
  before_filter :set_mosaic, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

  respond_to :html

  def index
    @mosaics = Mosaic.all
    respond_with(@mosaics)
  end

  def show
    respond_with(@mosaic)
  end

  def new
    @mosaic = Mosaic.new
    respond_with(@mosaic)
  end

  def edit
  end

  def create
    @mosaic = current_user.mosaics.new(params[:mosaic])
    @mosaic.save
    path = MosaicMaker.create_new(@mosaic)
    @mosaic.update_attribute(:path, path)
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
