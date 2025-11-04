class Users::ConfirmationsController < Devise::ConfirmationsController
  # When user clicks the confirmation link in email
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      flash[:notice] = "Your email has been confirmed successfully. Welcome!"
      sign_in(resource)  # ✅ Automatically log them in
      redirect_to root_path  # or wherever you want (e.g. dashboard_path)
    else
      flash[:alert] = resource.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end
end
