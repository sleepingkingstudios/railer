# app/models/contact.rb

class Contact
  include ActiveModel::Model

  ### Attributes ###

  attr_accessor :email_address, :message, :name

  ### Validations ###

  validates :email_address,
    :format => {
      :message => 'is not a valid email address',
      :unless  => ->(object) { object.email_address.blank? },
      :with    => /@/
    }, # end hash
    :presence => true

  ### Instance Methods ###

  def [] key
    return nil unless %w(email_address).include?(key.to_s)

    send key
  end # method []

  def []= key, value
    return nil unless %w(email_address).include?(key.to_s)

    send "#{key}=", value
  end # method []

  def formatted_email_address
    name.blank? ? email_address : "#{name} <#{email_address}>"
  end # method formatted_email_address

  def html_message
    return nil if message.blank?

    paragraphs = message.split(/\n\n+/)
    paragraphs.map do |paragraph|
      formatted = "<p>"
      lines     = paragraph.split(/\n/)
      lines.each.with_index do |line, index|
        formatted << "\n  <br>" unless 0 == index
        formatted << "\n  " << line
      end # each
      formatted << "\n</p>"
    end.join "\n"
  end # method html_message
end # class
