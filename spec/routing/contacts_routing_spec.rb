# spec/routing/contacts_routing_spec.rb

require 'rails_helper'

RSpec.describe 'ContactsController routing', :type => :routing do
  let(:controller) { 'contacts' }

  describe 'GET /contact/new' do
    let(:path) { '/contact/new' }

    it 'should route to ContactsController#new' do
      expect(:get => "/#{path}").to route_to({
        :controller  => controller,
        :action      => 'new'
      }) # end hash
    end # it
  end # describe

  describe 'POST /contact' do
    let(:path) { '/contact' }

    it 'should route to ContactsController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => controller,
        :action      => 'create'
      }) # end hash
    end # it
  end # describe
end # describe
