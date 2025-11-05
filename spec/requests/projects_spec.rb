require "rails_helper"

RSpec.describe "Projects", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user)  { create(:user, :confirmed) }
  let(:other) { create(:user, :confirmed) }
  let!(:project) { create(:project, author: user, status: "open") }


  describe "GET /projects" do
    context "without query" do
       before { sign_in user }
      it "shows all projects" do
        get projects_path
        expect(response).to have_http_status(:ok).or have_http_status(:success)
      end
    end

    context "with query and logged in" do
      before { sign_in user }

      it "calls fuzzy_search_all and returns results" do
        allow_any_instance_of(ProjectsController).to receive(:fuzzy_search_all)
          .with("test").and_return([ { type: "Project", record: project } ])

        get projects_path, params: { query: "test" }
        expect(response).to be_successful
      end
    end

    context "with query and not logged in" do
      it "redirects to login" do
        get projects_path, params: { query: "test" }
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end
  end

  describe "POST /projects" do
    before { sign_in user }

    it "creates a project successfully" do
      expect {
        post projects_path, params: { project: { title: "DS Project", description: "Fun", skills: "Ruby", role_cnt: 3 } }
      }.to change(Project, :count).by(1)
      expect(response).to redirect_to(project_path(Project.last))
      expect(flash[:notice]).to eq("Project was successfully created.")
    end

    it "renders :new on failure" do
      post projects_path, params: { project: { title: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /projects/:id" do
    before { sign_in user }

    it "updates successfully" do
      patch project_path(project), params: { project: { title: "Updated" } }
      expect(response).to redirect_to(project_path(project))
      expect(flash[:notice]).to eq("Project was successfully updated.")
    end

    it "renders edit on failure" do
      patch project_path(project), params: { project: { title: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /projects/:id" do
    before { sign_in user }

    it "destroys project" do
      expect { delete project_path(project) }.to change(Project, :count).by(-1)
      expect(response).to redirect_to(projects_path)
      expect(flash[:notice]).to eq("Project was successfully destroyed.")
    end
  end

  describe "PATCH /projects/:id/close" do
    before { sign_in user }

    it "closes project if author" do
      patch close_project_path(project)
      expect(response).to redirect_to(project_path(project))
      expect(flash[:notice]).to eq("Project listing closed!")
    end

    it "blocks non-author" do
      sign_in other
      patch close_project_path(project)
      expect(flash[:alert]).to eq("You don’t have permission to close this project.")
    end
  end

  describe "PATCH /projects/:id/reopen" do
    before { sign_in user }

    it "reopens project if author" do
      project.update(status: "closed")
      patch reopen_project_path(project)
      expect(response).to redirect_to(project_path(project))
      expect(flash[:notice]).to eq("Project listing reopened!")
    end

    it "blocks non-author" do
      sign_in other
      patch reopen_project_path(project)
      expect(flash[:alert]).to eq("You don’t have permission to reopen this project.")
    end
  end
end
