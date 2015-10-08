class BoxesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_box, only: [:show, :edit, :update, :destroy]

  # GET /boxes
  def index
    @boxes = current_user.boxes
  end

  # GET /boxes/1
  def show
  end

  # GET /boxes/new
  def new
    @box = current_user.boxes.new
  end

  # GET /boxes/1/edit
  def edit
  end

  # POST /boxes
  def create
    @box = current_user.boxes.new(box_params)

    if @box.save
      redirect_to @box, notice: 'Box was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if @box.update(box_params)
      redirect_to @box, notice: 'Box was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /boxes/1
  def destroy
    @box.destroy
    redirect_to boxes_url, notice: 'Box was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box
      @box = current_user.boxes.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def box_params
      params.require(:box).permit(:name, :slug)
    end
end
