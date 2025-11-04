require 'rails_helper'

RSpec.describe "BulletinPosts", type: :request do
  let!(:owner) { User.create!(name: "Owner User", email: "owner@tamu.edu", password: "Password!") }
  let!(:non_owner) { User.create!(name: "Other User", email: "other@tamu.edu", password: "Password!") }

  let!(:bulletin_post) { BulletinPost.create!(title: "Original Title", description: "Original description.", author: owner) }

  let(:valid_post_attributes) { { title: "A New Valid Title", description: "Some valid description." } }
  let(:invalid_post_attributes) { { title: "", description: "This is invalid." } }


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
        it "calls the search helper and renders the results" do
          search_result = [ { type: "BulletinPost", record: bulletin_post } ]

          allow_any_instance_of(BulletinPostsController).to receive(:fuzzy_search_all).with("Original").and_return(search_result)

          get bulletin_posts_path, params: { query: "Original" }

          expect(response).to be_successful
          expect(response.body).to include(bulletin_post.title)
        end
      end
    end
  end

  # --- SHOW ACTION ---
  describe "GET /bulletin_posts/:id" do
    it "succeeds for any user" do
      get bulletin_post_path(bulletin_post)
      expect(response).to be_successful
      expect(response.body).to include(bulletin_post.title)
    end
  end

  # --- NEW ACTION ---
  describe "GET /bulletin_posts/new" do
    context "when logged in" do
      before { sign_in owner }
      it "succeeds" do
        get new_bulletin_post_path
        expect(response).to be_successful
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get new_bulletin_post_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # --- EDIT ACTION ---
  describe "GET /bulletin_posts/:id/edit" do
    it "succeeds for any user" do
      get edit_bulletin_post_path(bulletin_post)
      expect(response).to be_successful
    end
  end

  # --- CREATE ACTION ---
  describe "POST /bulletin_posts" do
    context "when logged in" do
      before { sign_in owner }

      context "with valid parameters" do
        it "creates a new BulletinPost" do
          expect {
            post bulletin_posts_path, params: { bulletin_post: valid_post_attributes }
          }.to change(BulletinPost, :count).by(1)

          expect(response).to redirect_to(bulletin_post_path(BulletinPost.last))
          expect(flash[:notice]).to eq("Bulletin post was successfully created.")
          expect(BulletinPost.last.author).to eq(owner)
        end
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        post bulletin_posts_path, params: { bulletin_post: valid_post_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # --- UPDATE ACTION ---
  describe "PATCH /bulletin_posts/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "Updated Title" } }

      it "updates the requested bulletin_post" do
        patch bulletin_post_path(bulletin_post), params: { bulletin_post: new_attributes }
        bulletin_post.reload
        expect(bulletin_post.title).to eq("Updated Title")
        expect(response).to redirect_to(bulletin_post_path(bulletin_post))
        expect(flash[:notice]).to eq("Bulletin post was successfully updated.")
      end

      it "updates the requested bulletin_post via JSON" do
        patch bulletin_post_path(bulletin_post), params: { bulletin_post: new_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        bulletin_post.reload
        expect(bulletin_post.title).to eq("Updated Title")
      end
    end
  end

  # --- DESTROY ACTION ---
  describe "DELETE /bulletin_posts/:id" do
    it "destroys the requested bulletin_post" do
      expect {
        delete bulletin_post_path(bulletin_post)
      }.to change(BulletinPost, :count).by(-1)
      expect(response).to redirect_to(bulletin_posts_path)
      expect(flash[:notice]).to eq("Bulletin post was successfully destroyed.")
    end

    it "destroys the requested bulletin_post via JSON" do
      expect {
        delete bulletin_post_path(bulletin_post), as: :json
      }.to change(BulletinPost, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  it "allows guests to view the bulletin" do
    get bulletin_posts_path
    expect(response).to have_http_status(:ok)
  end
end
