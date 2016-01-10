# spec/routing/contacts_routing_spec.rb

require 'rails_helper'

RSpec.describe 'ContactsController routing', :type => :routing do
  let(:controller) { 'contacts' }

  describe 'POST /contact' do
    let(:path) { '/contact' }

    it 'routes to ContactsController#create' do
      expect(:post => "/#{path}").to route_to({
        :controller  => controller,
        :action      => 'create'
      }) # end hash
    end # it
  end # describe
end # describe
