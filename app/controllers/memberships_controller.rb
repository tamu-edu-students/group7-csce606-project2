class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    memberable = params[:memberable_type].constantize.find(params[:memberable_id])
    membership = Membership.new(user: current_user, memberable: memberable)

    if membership.save
      redirect_back fallback_location: root_path, notice: "You joined!"
    else
      redirect_back fallback_location: root_path, alert: "Already a member or failed."
    end
  end

  def destroy
  membership = Membership.find_by(
    user_id: current_user.id,
    memberable_type: params[:memberable_type].classify, # normalize casing
    memberable_id: params[:memberable_id]
  )

  if membership
    membership.destroy!
    redirect_back fallback_location: root_path, notice: "You left the membership."
  else
    redirect_back fallback_location: root_path, alert: "Membership not found."
  end
end

end
