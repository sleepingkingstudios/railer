Rails.application.routes.draw do
  resource :contact, :only => %i(create)

  match '/contact' => 'contacts#create', :via => :options
end # routes
