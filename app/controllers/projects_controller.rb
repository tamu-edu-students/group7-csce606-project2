class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy close reopen ]
  include SearchHelper
  # GET /projects or /projects.json
  def index
    # @project = Project.all
    if params[:query].present?
      if user_signed_in?
        @projects = fuzzy_search_all(params[:query]).select { |r| r[:type] == "Project" }
                        .map { |r| r[:record] }
      else
        redirect_to new_user_session_path,
                    alert: "You must be logged in to search projects."
      end
    else
      @projects = Project.all
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.author = current_user # THIS IS TEMPORARY!

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

    # CLOSE /projects/1/close
    def close
    if current_user == @project.author
      @project.update(status: "closed")
      redirect_to @project, notice: "Project listing closed!"
    else
      redirect_to @project, alert: "You don’t have permission to close this project."
    end
  end

    # REOPEN /projects/1/reopen
    def reopen
    if current_user == @project.author
      @project.update(status: "open")
      redirect_to @project, notice: "Project listing reopened!"
    else
      redirect_to @project, alert: "You don’t have permission to reopen this project."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, :description, :skills, :role_cnt)
    end
end
