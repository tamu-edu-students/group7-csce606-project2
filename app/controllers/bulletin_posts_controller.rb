class BulletinPostsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create]
  # before_action :authenticate_user!  #the method to get user
  # Public landing page
  skip_before_action :authenticate_user!, only: [ :index, :show, :destroy, :edit]
  before_action :set_bulletin_post, only: %i[edit update]
  # GET /bulletin_posts or /bulletin_posts.json
  def index
    if params[:query].present?
      if user_signed_in?
        search_term = "%#{params[:query]}%"
        @bulletin_posts = BulletinPost.where("title LIKE ? OR description LIKE ?", search_term, search_term)
      else
        redirect_to new_user_session_path, alert: "You must be logged in to search bulletin posts."
        nil
      end
    else
      @bulletin_posts = BulletinPost.all
    end
  end

  # GET /bulletin_posts/1 or /bulletin_posts/1.json
  def show
    @bulletin_post = BulletinPost.find(params[:id])
  end

  # GET /bulletin_posts/new
  def new
    @bulletin_post = BulletinPost.new
  end

  # GET /bulletin_posts/1/edit
  def edit
  end

  # POST /bulletin_posts or /bulletin_posts.json
  def create
    @bulletin_post = BulletinPost.new(bulletin_post_params)
    # current_user = User.find(1)
    @bulletin_post.author = current_user # THIS IS TEMPORARY!

    if @bulletin_post.save
      redirect_to @bulletin_post, notice: "Bulletin post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
    # respond_to do |format|
    #   if @bulletin_post.save
    #     format.html { redirect_to @bulletin_post, notice: "Bulletin post was successfully created." }
    #     format.json { render :show, status: :created, location: @bulletin_post }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @bulletin_post.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /bulletin_posts/1 or /bulletin_posts/1.json
  def update
    respond_to do |format|
      if @bulletin_post.update(bulletin_post_params)
        format.html { redirect_to @bulletin_post, notice: "Bulletin post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @bulletin_post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bulletin_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulletin_posts/1 or /bulletin_posts/1.json
  def destroy
    @bulletin_post = BulletinPost.find(params[:id])
    @bulletin_post.destroy!

    respond_to do |format|
      format.html { redirect_to bulletin_posts_path, notice: "Bulletin post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulletin_post
      @bulletin_post = BulletinPost.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bulletin_post_params
      params.require(:bulletin_post).permit(:title, :description)
    end
end
