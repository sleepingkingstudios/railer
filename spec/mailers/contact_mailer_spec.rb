# spec/mailers/contact_mailer_spec.rb

require 'rails_helper'

RSpec.describe ContactMailer, :type => :mailer do
  describe '#contact_email' do
    let(:attributes) do
      { :email_address => 'user@example.com'
      } # end hash
    end # let
    let(:contact) { Contact.new attributes }
    let(:mail)    { described_class.contact_email contact }
    let(:body_html) do
      part = mail.body.parts.select { |part| part.content_type =~ /text\/html/ }.first
      raw  = part.try(:body).try(:raw_source)
      body = raw.split(/\<\/?body\>/)[1]
      body.sub(/\A\n/, '').split("\n").map { |s| s.sub(/\A {4}/, '').rstrip }.join("\n")
    end # let
    let(:body_text) do
      part = mail.body.parts.select { |part| part.content_type =~ /text\/plain/ }.first
      part.try(:body).try(:raw_source)
    end # let

    it 'should return an email message' do
      expect(described_class.contact_email contact).to be_a ActionMailer::MessageDelivery
    end # it

    it 'should set the sender email address' do
      expect(mail.from).to contain_exactly ENV['EXAMPLE_FROM_ADDRESS']
    end # it

    it 'should set the reply-to email address' do
      expect(mail.reply_to).to contain_exactly contact.email_address
    end # it

    it 'should set the recipient email address' do
      expect(mail.to).to contain_exactly ENV['EXAMPLE_TO_ADDRESS']
    end # it

    it 'should set the subject line' do
      expect(mail.subject).to be == ENV['EXAMPLE_SUBJECT']
    end # it

    it 'should set the body html' do
      expected = <<-HTML
<h1>Sleeping King Studios</h1>
<p>
  #{contact.email_address} sent a contact request at <a href="sleepingkingstudios.com/contact.html">sleepingkingstudios.com/contact</a>.
</p>
      HTML

      expect(body_html).to be == expected
    end # it

    it 'should set the body text' do
      expected = <<-TEXT
Sleeping King Studios
================================================================================

#{contact.email_address} sent a contact request at sleepingkingstudios.com/contact.
      TEXT

      expect(body_text).to be == expected
    end # it
  end # describe
end # describe
