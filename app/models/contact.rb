# app/models/contact.rb

class Contact
  include ActiveModel::Model

  ### Attributes ###

  attr_accessor :email_address

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
end # class
