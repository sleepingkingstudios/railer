# spec/controllers/contacts_controller_spec.rb

require 'rails_helper'

RSpec.describe ContactsController, :type => :controller do
  let(:params)  { {} }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:json)    { begin JSON.parse(response.body); rescue JSON::ParserError; nil; end }

  describe '#create' do
    shared_examples 'should respond with' do |status, proc = nil|
      status_code = case status
      when Symbol
        Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      when String
        status.to_i
      else
        status
      end # case

      it "should respond with #{status_code.to_s} #{Rack::Utils::HTTP_STATUS_CODES[status_code]}" do
        perform_action

        expect(response.status).to be == status_code

        SleepingKingStudios::Tools::ObjectTools.apply(self, proc) if proc.is_a?(Proc)
      end # if
    end # shared_examples

    let(:message)        { json.fetch('message', nil) }
    let(:errors)         { json.fetch('errors', {}) }
    let(:contact_errors) { errors.fetch('contact', {}) }

    def perform_action
      xhr :post, :create, params, headers
    end # method perform_action

    include_examples 'should respond with', 400, ->() {
      expect(message).to be == 'Unable to send contact request'

      expect(contact_errors.fetch 'base').to be_a Array
      expect(contact_errors.fetch 'base').to contain_exactly "Contact can't be blank"
    } # end include_examples

    describe 'with invalid parameters for a contact' do
      let(:contact) { { :email_address => '867-5309' } }
      let(:params)  { super().merge :contact => contact }

      include_examples 'should respond with', 422, ->() {
        expect(message).to be == 'Unable to send contact request'

        expect(contact_errors.fetch 'email_address').to be_a Array
        expect(contact_errors.fetch 'email_address').to contain_exactly 'is not a valid email address'
      } # end include_examples
    end # describe

    describe 'with valid parameters for a contact' do
      let(:contact) { { :email_address => 'user@example.com' } }
      let(:params)  { super().merge :contact => contact }

      include_examples 'should respond with', 201, ->() {
        expect(message).to be == 'Successfully sent contact request'

        expect(errors).to be_empty
      } # end include_examples

      it 'should send a contact email' do
        mail = double('mail', :deliver_now => nil)

        expect(ContactMailer).to receive(:contact_email) do |contact|
          expect(contact.email_address).to be == params[:contact][:email_address]

          mail
        end # expect

        expect(mail).to receive(:deliver_now)

        perform_action
      end # describe
    end # describe
  end # describe
end # describe
