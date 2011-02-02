class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  protected

  def layout_by_resource
    is_a?(Devise::SessionsController) ? false : "application"
  end
end
