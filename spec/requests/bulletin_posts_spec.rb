# spec/requests/bulletin_posts_spec.rb
require "rails_helper"

RSpec.describe "BulletinPosts", type: :request do
  #
  # ───────────────────────────────
  # Setup
  # ───────────────────────────────
  #
  let!(:owner)      { create(:user, :tutor) }
  let!(:non_owner)  { create(:user, :learner) }
  let!(:bulletin_post) { create(:bulletin_post, title: "Original Title", description: "Original description.", author: owner) }

  let(:valid_post_attributes)   { attributes_for(:bulletin_post, title: "A New Valid Title", description: "Some valid description.") }
  let(:invalid_post_attributes) { attributes_for(:bulletin_post, title: "", description: "This is invalid.") }

  #
  # ───────────────────────────────
  # INDEX ACTION
  # ───────────────────────────────
  #
  describe "GET /bulletin_posts" do
    context "when not logged in" do
      it "shows all posts" do
        get bulletin_posts_path
        expect(response).to be_successful
        expect(response.body).to include(bulletin_post.title)
      end
    end

    context "when logged in" do
      before { sign_in owner }

      it "shows all posts" do
        get bulletin_posts_path
        expect(response).to be_successful
        expect(response.body).to include(bulletin_post.title)
      end

      context "with a search query" do
        it "calls the fuzzy search helper and renders the results" do
          search_result = [ { type: "BulletinPost", record: bulletin_post } ]

          allow_any_instance_of(BulletinPostsController)
            .to receive(:fuzzy_search_all)
            .with("Original")
            .and_return(search_result)

          get bulletin_posts_path, params: { query: "Original" }

          expect(response).to be_successful
          expect(response.body).to include(bulletin_post.title)
        end
      end
    end
  end

  #
  # ───────────────────────────────
  # SHOW ACTION
  # ───────────────────────────────
  #
  describe "GET /bulletin_posts/:id" do
    it "is accessible to anyone" do
      get bulletin_post_path(bulletin_post)
      expect(response).to be_successful
      expect(response.body).to include(bulletin_post.title)
    end
  end

  #
  # ───────────────────────────────
  # NEW ACTION
  # ───────────────────────────────
  #
  describe "GET /bulletin_posts/new" do
    context "when logged in" do
      before { sign_in owner }

      it "renders the new page successfully" do
        get new_bulletin_post_path
        expect(response).to be_successful
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get new_bulletin_post_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  #
  # ───────────────────────────────
  # EDIT ACTION
  # ───────────────────────────────
  #
  describe "GET /bulletin_posts/:id/edit" do
    it "renders successfully" do
      get edit_bulletin_post_path(bulletin_post)
      expect(response).to be_successful
    end
  end

  #
  # ───────────────────────────────
  # CREATE ACTION
  # ───────────────────────────────
  #
  describe "POST /bulletin_posts" do
    context "when logged in" do
      before { sign_in owner }

      it "creates a new BulletinPost with valid parameters" do
        expect {
          post bulletin_posts_path, params: { bulletin_post: valid_post_attributes }
        }.to change(BulletinPost, :count).by(1)

        new_post = BulletinPost.last
        expect(response).to redirect_to(bulletin_post_path(new_post))
        expect(flash[:notice]).to eq("Bulletin post was successfully created.")
        expect(new_post.author).to eq(owner)
      end

      it "does not create a post with invalid parameters" do
        expect {
  post bulletin_posts_path, params: { bulletin_post: invalid_post_attributes }
}.not_to change(BulletinPost, :count)

expect(response).to have_http_status(:no_content).or have_http_status(:unprocessable_entity)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        post bulletin_posts_path, params: { bulletin_post: valid_post_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  #
  # ───────────────────────────────
  # UPDATE ACTION
  # ───────────────────────────────
  #
  describe "PATCH /bulletin_posts/:id" do
    let(:new_attributes) { { title: "Updated Title" } }

    it "updates a bulletin post with valid attributes" do
      patch bulletin_post_path(bulletin_post), params: { bulletin_post: new_attributes }
      bulletin_post.reload
      expect(bulletin_post.title).to eq("Updated Title")
      expect(response).to redirect_to(bulletin_post_path(bulletin_post))
      expect(flash[:notice]).to eq("Bulletin post was successfully updated.")
    end

    it "updates successfully via JSON" do
      patch bulletin_post_path(bulletin_post), params: { bulletin_post: new_attributes }, as: :json
      bulletin_post.reload
      expect(bulletin_post.title).to eq("Updated Title")
      expect(response).to have_http_status(:ok)
    end
  end

  #
  # ───────────────────────────────
  # DESTROY ACTION
  # ───────────────────────────────
  #
  describe "DELETE /bulletin_posts/:id" do
    it "destroys a bulletin post" do
      expect {
        delete bulletin_post_path(bulletin_post)
      }.to change(BulletinPost, :count).by(-1)
      expect(response).to redirect_to(bulletin_posts_path)
      expect(flash[:notice]).to eq("Bulletin post was successfully destroyed.")
    end

    it "destroys successfully via JSON" do
      expect {
        delete bulletin_post_path(bulletin_post), as: :json
      }.to change(BulletinPost, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  #
  # ───────────────────────────────
  # Guest Access
  # ───────────────────────────────
  #
  it "allows guests to view the bulletin index" do
    get bulletin_posts_path
    expect(response).to have_http_status(:ok)
  end
end
