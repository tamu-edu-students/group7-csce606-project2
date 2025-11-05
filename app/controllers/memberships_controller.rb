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
        message: "#{current_user.name} has requested to join your #{memberable_name}.",
        url: memberable_path(@memberable)
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

    if membership.update(status: "approved")
      Notification.create!(
        user: membership.user,
        notifiable: membership,
        message: "Your request to join #{memberable_name} '#{@memberable.title}' has been approved!",
        url: memberable_path(@memberable)
      )

      redirect_back fallback_location: memberable_memberships_path(@memberable),
                    notice: "#{membership.user.name} has been approved."
    else
       Rails.logger.warn "APPROVAL FAILED: #{membership.errors.full_messages.inspect}"
      redirect_back fallback_location: memberable_memberships_path(@memberable),
                    alert: membership.errors.full_messages.to_sentence
    end
  end
  # Tutor rejects a join request
  def reject
    membership = Membership.find(params[:id])

    if current_user == membership.memberable.author
      membership.update(status: "rejected")

      Notification.create!(
        user: membership.user,
        notifiable: membership,
        message: "Your request to join #{memberable_name} '#{@memberable.title}' has been rejected.",
        url: memberable_path(@memberable)
      )

      redirect_back fallback_location: memberable_path(@memberable),
                    notice: "#{membership.user.name}'s request has been rejected."
    else
      redirect_back fallback_location: root_path, alert: "You don't have permission to do that."
    end
  end

  # Learner cancels membership
  def destroy
    membership = @memberable.memberships.find_by(user: current_user)
    if membership
      Notification.create!(
        user: @memberable.author,
        notifiable: membership,
        message: "#{current_user.name} has left your #{memberable_name}.",
        url: memberable_path(@memberable)
      )
      membership.destroy!
      redirect_back fallback_location: root_path, notice: "You left this #{memberable_name}."
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
    @memberable.class.name.demodulize.downcase
  end

  # Dynamic path helper based on memberable type
  def memberable_path(memberable)
    case memberable
    when TeachingOffer
      teaching_offer_path(memberable)
    when Project
      project_path(memberable)
    else
      root_path
    end
  end

  # Dynamic path helper for memberships index
  def memberable_memberships_path(memberable)
    case memberable
    when TeachingOffer
      teaching_offer_memberships_path(memberable)
    when Project
      project_memberships_path(memberable)
    else
      root_path
    end
  end
end
