# app/mailers/contact_mailer.rb

class ContactMailer < ActionMailer::Base
  default :from => ENV['EXAMPLE_FROM_ADDRESS']

  def contact_email contact
    @contact = contact
    subject  = ENV['EXAMPLE_SUBJECT']

    mail(
      :to       => ENV['EXAMPLE_TO_ADDRESS'],
      :reply_to => contact.email_address,
      :subject  => "You have a new contact request at sleepingkingstudios.com"
    ) # end mail
  end # action contact_email
end # class
