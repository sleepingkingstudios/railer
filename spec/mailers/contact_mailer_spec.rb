# spec/mailers/contact_mailer_spec.rb

require 'rails_helper'

RSpec.describe ContactMailer, :type => :mailer do
  describe '#contact_email' do
    it 'should return an email message' do
      expect(described_class.contact_email).to be_a ActionMailer::MessageDelivery
    end # it
  end # describe
end # describe
