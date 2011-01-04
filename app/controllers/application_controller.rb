class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  protected
  def render_404
    render :file => 'public/404.html', :layout => false,
      :status => :not_found
  end
end
