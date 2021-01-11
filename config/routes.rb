Rails.application.routes.draw do
  root 'cmd_pallet#index'
  get 'cmd_pallet/index'
  get 'cmd_pallet/new'
  get 'cmd_pallet/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
