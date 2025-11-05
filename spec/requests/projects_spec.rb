require 'rails_helper'

RSpec.describe "Projects management", type: :request do
  let!(:project) { Project.create!(title: "Cache Design", description: "L1 cache", skills: "Verilog") }

  describe "PATCH /projects/:id/close" do
    it "sets status to closed" do
      patch close_project_path(project)
      expect(response).to redirect_to(project_path(project))
      expect(project.reload.status).to eq("closed")
    end
  end

  describe "PATCH /projects/:id/reopen" do
    before { project.update!(status: "closed") }

    it "sets status to open" do
      patch reopen_project_path(project)
      expect(response).to redirect_to(project_path(project))
      expect(project.reload.status).to eq("open")
    end
  end

  describe "GET /projects" do
    it "does not show closed projects" do
      project.update!(status: "closed")
      get projects_path
      expect(response.body).not_to include("Cache Design")
    end
  end
end
