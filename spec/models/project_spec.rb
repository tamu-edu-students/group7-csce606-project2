require "rails_helper"

RSpec.describe Project, type: :model do
  describe "associations" do
    it { should belong_to(:author).class_name("User") }
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:users).through(:memberships) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:skills) }
  end

  describe "instance methods" do
    let(:project) { build(:project, status: "open") }

    it "returns true for open? when status is open" do
      expect(project.open?).to be true
    end

    it "returns false for open? when closed" do
      project.status = "closed"
      expect(project.open?).to be false
    end

    it "returns true for closed? when status is closed" do
      project.status = "closed"
      expect(project.closed?).to be true
    end
  end
end
