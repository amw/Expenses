Expenses::Application.routes.draw do
  resources :transactions, :except => [:show, :new]
  resources :categories, :only => [:show, :update]
  root :to => "transactions#index"
end
