# spec/controllers/contacts_controller_spec.rb

require 'rails_helper'

RSpec.describe ContactsController, :type => :controller do
  shared_examples 'should set access control headers' do
    describe 'with no allowed access control origins' do
      around(:each) do |example|
        RSpec::SleepingKingStudios.stub_env({
          'ACCESS_CONTROL_ALLOW_ORIGIN' => ''
        }) { example.call }
      end # around each

      it 'should not set access control headers' do
        perform_action

        expect(response.headers).not_to have_key 'Access-Control-Allow-Origin'
      end # it
    end # describe

    describe 'with allowed access control origins' do
      around(:each) do |example|
        RSpec::SleepingKingStudios.stub_env({
          'ACCESS_CONTROL_ALLOW_ORIGIN' => 'http://example.com'
        }) { example.call }
      end # around each

      it 'should set access control headers' do
        perform_action

        expect(response.headers['Access-Control-Allow-Origin']).to  be == 'http://example.com'
        expect(response.headers['Access-Control-Allow-Methods']).to be == 'POST, OPTIONS'
        expect(response.headers['Access-Control-Allow-Headers']).to be == 'Origin, Content-Type, Accept'
        expect(response.headers['Access-Control-Max-Age']).to       be == 14.days.to_s
      end # it
    end # describe
  end # shared_examples

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
      shared_examples 'should send a contact email' do |proc|
        it 'should send a contact email' do
          mail = double('mail', :deliver_now => nil)

          expect(ContactMailer).to receive(:contact_email) do |contact|
            expect(contact.email_address).to be == params[:contact][:email_address]

            SleepingKingStudios::Tools::ObjectTools.apply(self, proc, contact) if proc.is_a?(Proc)

            mail
          end # expect

          expect(mail).to receive(:deliver_now)

          perform_action
        end # describe
      end # shared_examples

      let(:contact) { { :email_address => 'user@example.com' } }
      let(:params)  { super().merge :contact => contact }

      include_examples 'should respond with', 201, ->() {
        expect(message).to be == 'Successfully sent contact request'

        expect(errors).to be_empty
      } # end include_examples

      include_examples 'should send a contact email'

      include_examples 'should set access control headers'

      describe 'with an optional name parameter' do
        let(:contact) { super().merge :name => 'Example User' }

        include_examples 'should respond with', 201, ->() {
          expect(message).to be == 'Successfully sent contact request'

          expect(errors).to be_empty
        } # end include_examples

        include_examples 'should send a contact email', ->(contact) {
          expect(contact.name).to be == params[:contact][:name]
        } # end include_examples
      end # describe

      describe 'with plain text as an optional message parameter' do
        let(:contact) { super().merge :message => 'Your ideas intrigue me, and I wish to subscribe to your newsletter.' }

        include_examples 'should respond with', 201, ->() {
          expect(message).to be == 'Successfully sent contact request'

          expect(errors).to be_empty
        } # end include_examples

        include_examples 'should send a contact email', ->(contact) {
          expect(contact.message).to be == params[:contact][:message]
        } # end include_examples
      end # describe

      describe 'with html with a link as an optional message parameter' do
        let(:contact) { super().merge :message => 'I am a spammer and wish you to buy <a href="www.example.com">V1agra</a>.' }

        include_examples 'should respond with', 201, ->() {
          expect(message).to be == 'Successfully sent contact request'

          expect(errors).to be_empty
        } # end include_examples

        include_examples 'should send a contact email', ->(contact) {
          expect(contact.message).to be == params[:contact][:message]
        } # end include_examples
      end # describe

      describe 'with html with a script tag as an optional message parameter' do
        let(:contact)  { super().merge :message => '<script>maliciousJs()</script><p>I am trying to harvest your email address and/or organs.</p>' }
        let(:expected) { 'I am trying to harvest your email address and/or organs.' }

        include_examples 'should respond with', 201, ->() {
          expect(message).to be == 'Successfully sent contact request'

          expect(errors).to be_empty
        } # end include_examples

        include_examples 'should send a contact email', ->(contact) {
          expect(contact.message).to be == expected
        } # end include_examples
      end # describe
    end # describe

    describe 'with an OPTIONS request' do
      def perform_action
        process :create, 'OPTIONS', params, headers
      end # method perform_action

      include_examples 'should set access control headers'
    end # describe
  end # describe
end # describe
