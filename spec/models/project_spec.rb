require 'rails_helper'

RSpec.describe Project, type: :model do
  it "is valid with valid attributes" do
    project = Project.new(title: "AI Accelerator", description: "Build a neural net accelerator", skills: "Verilog, SystemVerilog")
    expect(project).to be_valid
  end

  it "is invalid without a title" do
    project = Project.new(description: "Missing title", skills: "Python")
    expect(project).not_to be_valid
  end

  it "is invalid without skills" do
    project = Project.new(title: "FPGA", description: "Missing skills")
    expect(project).not_to be_valid
  end

  it "defaults to status 'open'" do
    project = Project.create!(title: "RISC-V", description: "CPU design", skills: "SystemVerilog")
    expect(project.status).to eq("open")
  end
end
