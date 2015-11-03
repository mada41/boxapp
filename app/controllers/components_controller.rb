class ComponentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_box
  before_action :set_component, only: [:show, :edit, :update, :destroy]
  before_action :set_action_url, only: [:new, :edit, :create, :update]

  # GET /components
  def index
    @components = @box.components
  end

  # GET /components/1
  def show
  end

  # GET /components/new
  def new
    @component = @box.components.new
  end

  # GET /components/1/edit
  def edit
  end

  # POST /components
  def create
    @component = @box.components.new(component_params)

    if @component.save
      redirect_to box_components_url, notice: 'Component was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /components/1
  def update
    if @component.update(component_params)
      redirect_to @component, notice: 'Component was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /components/1
  def destroy
    @component.destroy
    redirect_to box_components_url, notice: 'Component was successfully destroyed.'
  end

  private
    def set_box
      @box = current_user.boxes.find(params[:box_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = @box.components.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def component_params
      params.require(:component).permit(:name, :type, :c_type, :box_id)
    end

    def set_action_url
      @action_url = box_components_url
    end
end
