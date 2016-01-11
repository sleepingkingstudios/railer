# app/mailers/contact_mailer.rb

class ContactMailer < ActionMailer::Base
  default :from => ENV['CONTACT_FROM_ADDRESS']

  def contact_email contact
    @contact = contact
    subject  = ENV['CONTACT_SUBJECT']

    mail(
      :to       => ENV['CONTACT_TO_ADDRESS'],
      :reply_to => contact.formatted_email_address,
      :subject  => "You have a new contact request at sleepingkingstudios.com"
    ) # end mail
  end # action contact_email
end # class
