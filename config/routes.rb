Rails.application.routes.draw do
  root 'cmd_pallet#index'
  get 'cmd_pallet/index'
  get 'cmd_pallet/new'
  post 'cmd_pallet' => 'cmd_pallet#show'
  # get 'cmd_pallet/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
