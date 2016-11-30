Rails.application.routes.draw do
  resource :sequence, only: [:show, :create]

  mount ActionCable.server => '/cable'
end
