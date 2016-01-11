# spec/models/contact_spec.rb

require 'rails_helper'

RSpec.describe Contact, :type => :model do
  include RSpec::SleepingKingStudios::Examples::ActiveModel::ValidationExamples

  let(:attributes) do
    { :email_address => 'user@example.com',
      :name          => 'Example User',
      :message       => 'Your ideas intrigue me, and I wish to subscribe to your newsletter.'
    } # end hash
  end # let
  let(:instance) { described_class.new attributes }

  it { expect(instance).to have_property(:email_address).with_value(attributes[:email_address]) }

  it { expect(instance).to have_property(:name).with_value(attributes[:name]) }

  it { expect(instance).to have_property(:message).with_value(attributes[:message]) }

  ### Validations ###

  it { expect(instance).to be_valid }

  include_examples 'should validate presence of', :email_address

  describe 'with an invalid email address' do
    let(:attributes) { super().merge :email_address => '867-5309' }

    it { expect(instance).to have_errors.on(:email_address).with_message('is not a valid email address') }
  end # describe

  ### Instance Methods ###

  describe '#formatted_email_address' do
    it { expect(instance).to have_reader(:formatted_email_address) }

    context 'without a name' do
      let(:attributes) { super().merge :name => nil }

      it { expect(instance.formatted_email_address).to be == attributes[:email_address] }
    end # context

    context 'with a name' do
      let(:attributes) { super().merge :name => 'Example User' }
      let(:expected)   { "#{attributes[:name]} <#{attributes[:email_address]}>" }

      it { expect(instance.formatted_email_address).to be == expected }
    end # context
  end # describe

  describe '#html_message' do
    it { expect(instance).to have_reader(:html_message) }

    context 'without a message' do
      let(:attributes) { super().merge :message => nil }

      it { expect(instance.html_message).to be nil }
    end # context

    context 'with a single-line message' do
      let(:attributes) { super().merge :message => 'Your ideas intrigue me, and I wish to subscribe to your newsletter.' }
      let(:expected)   { "<p>\n  #{attributes[:message]}\n</p>" }

      it { expect(instance.html_message).to be == expected }
    end # context

    context 'with a multi-line message' do
      let(:message) do
        <<-MESSAGE
What lies beyond the furthest reaches of the sky?
That which will lead the lost child back to her mother's arms. Exile.

The waves that flow and dye the land gold.
The blessed breath that nurtures life. A land of wheat.

The path the angels descend upon.
The path of great winds. The Grand Stream.

What lies within the furthest depths of one's memory?
The place where all are born and all will return. A blue star.
        MESSAGE
      end # let
      let(:attributes) { super().merge :message => message }
      let(:expected) do
        <<-HTML
<p>
  What lies beyond the furthest reaches of the sky?
  <br>
  That which will lead the lost child back to her mother's arms. Exile.
</p>
<p>
  The waves that flow and dye the land gold.
  <br>
  The blessed breath that nurtures life. A land of wheat.
</p>
<p>
  The path the angels descend upon.
  <br>
  The path of great winds. The Grand Stream.
</p>
<p>
  What lies within the furthest depths of one's memory?
  <br>
  The place where all are born and all will return. A blue star.
</p>
        HTML
      end # let

      it { expect(instance.html_message).to be == expected.strip }
    end # context
  end # describe
end # describe
