# app/controllers/contacts_controller.rb

class ContactsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  protect_from_forgery :with => :null_session

  before_action :require_contact

  def create
    if contact.valid?
      if deliver_contact_email
        render :status => 201, :json => { :message => success_message }
      else
        errors = { :mailer => [$!.message] }

        render :status => 503, :json => { :message => failure_message }
      end # if-else
    else
      render :status => 422, :json => { :message => failure_message, :errors => { :contact => contact.errors.messages } }
    end # if-else
  end # method create

  private

  def contact
    @contact ||= Contact.new(contact_params)
  end # method contact

  def contact_params
    hsh = (params[:contact] || {}).permit(:email_address, :name)

    unless (raw_message = params[:contact][:message]).blank?
      script_scrubber = Loofah::Scrubber.new do |node|
        node.remove if node.name == 'script'
      end # scrubber

      sanitized = sanitize(raw_message, :scrubber => script_scrubber)
      sanitized = sanitize(sanitized, :tags => %w(a), :attributes => %w(href))

      hsh[:message] = sanitized
    end # unless

    hsh
  end # method contact_params

  def deliver_contact_email
    ContactMailer.contact_email(contact).deliver_now

    true
  rescue EOFError,
    IOError,
    TimeoutError,
    Errno::ECONNRESET,
    Errno::ECONNABORTED,
    Errno::EPIPE,
    Errno::ETIMEDOUT,
    Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPSyntaxError,
    Net::SMTPUnknownError,
    OpenSSL::SSL::SSLError => exception

    Rails::logger.error "#{failure_message} -- #{exception.to_s}"
    Rails::logger.error params

    false
  end # method deliver_contact_email

  def failure_message
    @failure_message ||= 'Unable to send contact request'
  end # method failure_message

  def require_contact
    return unless params[:contact].blank?

    errors  = { :contact => { :base => ["Contact can't be blank"] } }
    render :status => 400, :json => { :message => failure_message, :errors => errors }
  end # method require_contact

  def success_message
    @success_message ||= 'Successfully sent contact request'
  end # method success_message
end # class
