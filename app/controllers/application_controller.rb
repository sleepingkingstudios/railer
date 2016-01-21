# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  private

  def access_control_allow_methods
    @access_control_allow_methods ||= 'POST, GET, PUT, DELETE, OPTIONS'
  end # method access_control_allow_methods

  def cors_preflight
    return unless request.method == 'OPTIONS'

    set_access_control_headers

    render :text => '', :content_type => 'text/plain'
  end # method cors_preflight

  def set_access_control_headers
    return if ENV['ACCESS_CONTROL_ALLOW_ORIGIN'].blank?

    max_age = ENV['ACCESS_CONTROL_MAX_AGE'].to_i
    max_age = 14.days.to_i if 0 == max_age

    headers['Access-Control-Allow-Origin']  = ENV['ACCESS_CONTROL_ALLOW_ORIGIN']
    headers['Access-Control-Allow-Methods'] = access_control_allow_methods
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept'
    headers['Access-Control-Max-Age']       = max_age.to_s
  end # method set_access_control_headers
end # class
