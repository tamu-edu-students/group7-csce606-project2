require 'rails_helper'

RSpec.describe "BulletinPosts", type: :request do
  it "allows guests to view the bulletin" do
    get bulletin_posts_path
    expect(response).to have_http_status(:ok)
  end

  it "redirects guests to login when searching" do
    get bulletin_posts_path, params: { query: "test" }
    expect(response).to redirect_to(new_user_session_path)
  end
end