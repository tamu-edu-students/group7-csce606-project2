class BulletinPostsController < ApplicationController
  before_action :set_bulletin_post, only: %i[ show edit update destroy ]

  # GET /bulletin_posts or /bulletin_posts.json
  def index
    @bulletin_posts = BulletinPost.all
  end

  # GET /bulletin_posts/1 or /bulletin_posts/1.json
  def show
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
    @bulletin_post.author = User.first # THIS IS TEMPORARY!

    respond_to do |format|
      if @bulletin_post.save
        format.html { redirect_to @bulletin_post, notice: "Bulletin post was successfully created." }
        format.json { render :show, status: :created, location: @bulletin_post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bulletin_post.errors, status: :unprocessable_entity }
      end
    end
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
