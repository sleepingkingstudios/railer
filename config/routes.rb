Rails.application.routes.draw do
  resource :contact, :only => %i(new create)
end # routes
