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
      expect(mail.from).to contain_exactly ENV['CONTACT_FROM_ADDRESS']
    end # it

    it 'should set the reply-to email address' do
      expect(mail.reply_to).to contain_exactly contact.email_address
    end # it

    it 'should set the recipient email address' do
      expect(mail.to).to contain_exactly ENV['CONTACT_TO_ADDRESS']
    end # it

    it 'should set the subject line' do
      expect(mail.subject).to be == ENV['CONTACT_SUBJECT']
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

    describe 'with optional name parameter' do
      let(:attributes) { super().merge :name => 'Example User' }

      it 'should set the reply-to email address' do
        expect(mail.reply_to).to contain_exactly contact.email_address
      end # it

      it 'should set the body html' do
        expected = <<-HTML
<h1>Sleeping King Studios</h1>
<p>
  #{contact.name} &lt;#{contact.email_address}&gt; sent a contact request at <a href="sleepingkingstudios.com/contact.html">sleepingkingstudios.com/contact</a>.
</p>
        HTML

        expect(body_html).to be == expected
      end # it

      it 'should set the body text' do
        expected = <<-TEXT
Sleeping King Studios
================================================================================

#{contact.name} <#{contact.email_address}> sent a contact request at sleepingkingstudios.com/contact.
        TEXT

        expect(body_text).to be == expected
      end # it
    end # describe

    describe 'with an optional message parameter' do
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

      it 'should set the body html' do
        expected = <<-HTML
<h1>Sleeping King Studios</h1>
<p>
  #{contact.email_address} sent a contact request at <a href="sleepingkingstudios.com/contact.html">sleepingkingstudios.com/contact</a>.
</p>
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

        expect(body_html).to be == expected
      end # it

      it 'should set the body text' do
        expected = <<-TEXT
Sleeping King Studios
================================================================================

#{contact.email_address} sent a contact request at sleepingkingstudios.com/contact.

What lies beyond the furthest reaches of the sky?
That which will lead the lost child back to her mother's arms. Exile.

The waves that flow and dye the land gold.
The blessed breath that nurtures life. A land of wheat.

The path the angels descend upon.
The path of great winds. The Grand Stream.

What lies within the furthest depths of one's memory?
The place where all are born and all will return. A blue star.

        TEXT

        expect(body_text).to be == expected
      end # it
    end # describe
  end # describe
end # describe
