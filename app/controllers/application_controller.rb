class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :current_ability

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  protected
  def render_404
    render :file => 'public/404.html', :layout => false,
      :status => :not_found
  end

  def current_user
    nil
  end
end
