Dummy::Application.routes.draw do
  resources :articles, defaults: {format: 'json'}
end
