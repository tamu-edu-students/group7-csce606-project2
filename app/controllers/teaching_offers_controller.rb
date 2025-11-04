class TeachingOffersController < ApplicationController
  before_action :set_teaching_offer, only: %i[ show edit update destroy ]
  include SearchHelper
  # GET /teaching_offers or /teaching_offers.json
  def index
    if params[:query].present?
      if user_signed_in?
        @teaching_offers = fuzzy_search_all(params[:query]).select { |r| r[:type] == "TeachingOffer" }
                        .map { |r| r[:record] }
        
      else
        redirect_to new_user_session_path,
                    alert: "You must be logged in to search bulletin posts."
      end
    else
      @teaching_offers = TeachingOffer.all.order(created_at: :desc)
    end
  end

  # GET /teaching_offers/1 or /teaching_offers/1.json
  def show
  end

  # GET /teaching_offers/new
  def new
    @teaching_offer = TeachingOffer.new
  end

  # GET /teaching_offers/1/edit
  def edit
  end

  # POST /teaching_offers or /teaching_offers.json
  def create
    @teaching_offer = TeachingOffer.new(teaching_offer_params)
    @teaching_offer.author = current_user

    respond_to do |format|
      if @teaching_offer.save
        format.html { redirect_to @teaching_offer, notice: "Teaching offer was successfully created." }
        format.json { render :show, status: :created, location: @teaching_offer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teaching_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teaching_offers/1 or /teaching_offers/1.json
  def update
    respond_to do |format|
      if @teaching_offer.update(teaching_offer_params)
        format.html { redirect_to @teaching_offer, notice: "Teaching offer was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @teaching_offer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teaching_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teaching_offers/1 or /teaching_offers/1.json
  def destroy
    @teaching_offer.destroy!

    respond_to do |format|
      format.html { redirect_to teaching_offers_path, notice: "Teaching offer was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching_offer
      @teaching_offer = TeachingOffer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def teaching_offer_params
      params.require(:teaching_offer).permit(:title, :description, :student_cap)
    end
end
