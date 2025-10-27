class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :temp_current_user

  def temp_current_user 
    User.first || User.new(name: "Placeholder User", email:"Placeholder", password:"Placeholder")
  end
end
