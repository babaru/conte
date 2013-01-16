class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def layout_by_resource
    if devise_controller?
      "single"
    else
      "application"
    end
  end
end
