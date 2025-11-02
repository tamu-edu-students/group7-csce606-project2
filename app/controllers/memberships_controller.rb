class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memberable
  before_action :authorize_tutor!, only: [ :index, :approve ]

  # Learner requests to join
  def create
    membership = @memberable.memberships.build(user: current_user, status: :pending)

    if membership.save
      Notification.create!(
        user: @memberable.author,
        notifiable: membership,
        message: "#{current_user.name} has requested to join your #{@memberable.class.name.demodulize.downcase}."
      )
      @memberable.memberships.reload
      redirect_back fallback_location: root_path, notice: "Join request sent!"
    else
      redirect_back fallback_location: root_path, alert: membership.errors.full_messages.to_sentence
    end
  end

  # Tutor views pending join requests
  def index
    @pending_memberships = @memberable.pending_memberships.includes(:user)
  end

  # Tutor approves a join request
  def approve
    membership = @memberable.memberships.find(params[:id])
    membership.update(status: "approved")
    Notification.create!(
        user: membership.user,
        notifiable: membership,
        message: "Your request to join #{@memberable.class.name.demodulize.downcase} '#{@memberable.title}' has been approved!"
    )
    redirect_back fallback_location: teaching_offer_memberships_path(@memberable),
                  notice: "#{membership.user.name} has been approved."
  end

  # Tutor rejects a join request
  def reject
    membership = Membership.find(params[:id])

    if current_user == membership.memberable.author
      membership.update(status: "rejected")
      Notification.create!(
        user: membership.user,
        notifiable: membership,
        message: "Your request to join #{@memberable.class.name.demodulize.downcase} '#{@memberable.title}' has been rejected."
      )

      redirect_back fallback_location: teaching_offer_path(membership.memberable),
                    notice: "#{membership.user.name}'s request has been rejected."
    else
      redirect_back fallback_location: root_path, alert: "You don't have permission to do that."
    end
  end

  # Learner cancels membership
  def destroy
    membership = @memberable.memberships.find_by(user: current_user)
    if membership
      membership.destroy!
      redirect_back fallback_location: root_path, notice: "You left this #{memberable_name.downcase}."
    else
      redirect_back fallback_location: root_path, alert: "Membership not found."
    end
  end

  private

  def set_memberable
    if params[:teaching_offer_id]
      @memberable = TeachingOffer.find(params[:teaching_offer_id])
    elsif params[:project_id]
      @memberable = Project.find(params[:project_id])
    else
      redirect_to root_path, alert: "Invalid membership request."
    end
  end

  def authorize_tutor!
    redirect_to root_path, alert: "Not authorized." unless @memberable.author == current_user
  end

  def memberable_name
    @memberable.class.name.demodulize
  end
end
