# app/mailers/contact_mailer.rb

class ContactMailer < ActionMailer::Base
  default :from => ENV['EXAMPLE_FROM_ADDRESS']

  def contact_email
    mail(:to => ENV['EXAMPLE_TO_ADDRESS'], :subject => "You've got mail!")
  end # action contact_email
end # class
