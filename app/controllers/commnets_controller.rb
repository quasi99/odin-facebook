class CommnetsController < ApplicationController
  before_action :set_commnet, only: %i[ show edit update destroy ]

  # GET /commnets or /commnets.json
  def index
    @commnets = Commnet.all
  end

  # GET /commnets/1 or /commnets/1.json
  def show
  end

  # GET /commnets/new
  def new
    @commnet = Commnet.new
  end

  # GET /commnets/1/edit
  def edit
  end

  # POST /commnets or /commnets.json
  def create
    @commnet = Commnet.new(commnet_params)

    respond_to do |format|
      if @commnet.save
        format.html { redirect_to @commnet, notice: "Commnet was successfully created." }
        format.json { render :show, status: :created, location: @commnet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @commnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commnets/1 or /commnets/1.json
  def update
    respond_to do |format|
      if @commnet.update(commnet_params)
        format.html { redirect_to @commnet, notice: "Commnet was successfully updated." }
        format.json { render :show, status: :ok, location: @commnet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @commnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commnets/1 or /commnets/1.json
  def destroy
    @commnet.destroy
    respond_to do |format|
      format.html { redirect_to commnets_url, notice: "Commnet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commnet
      @commnet = Commnet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def commnet_params
      params.fetch(:commnet, {})
    end
end
