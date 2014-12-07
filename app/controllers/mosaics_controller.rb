class MosaicsController < ApplicationController
  before_filter :set_mosaic, only: [:show, :edit, :update, :destroy]

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
    @mosaic = Mosaic.new(params[:mosaic])
    @mosaic.save
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
