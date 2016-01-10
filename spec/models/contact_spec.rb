# spec/models/contact_spec.rb

require 'rails_helper'

RSpec.describe Contact, :type => :model do
  include RSpec::SleepingKingStudios::Examples::ActiveModel::ValidationExamples

  let(:attributes) do
    { :email_address => 'user@example.com'
    } # end hash
  end # let
  let(:instance) { described_class.new attributes }

  it { expect(instance).to have_property(:email_address).with_value(attributes[:email_address]) }

  # Validations

  it { expect(instance).to be_valid }

  include_examples 'should validate presence of', :email_address

  describe 'with an invalid email address' do
    let(:attributes) { super().merge :email_address => '867-5309' }

    it { expect(instance).to have_errors.on(:email_address).with_message('is not a valid email address') }
  end # describe
end # describe
