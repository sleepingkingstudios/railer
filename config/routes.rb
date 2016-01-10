Rails.application.routes.draw do
  resource :contact, :only => %i(create)
end # routes
