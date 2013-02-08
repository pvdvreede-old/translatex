Translatex::Application.routes.draw do
  resources :translations
  post '/translations/new' => 'translations#create'
  put '/translations/:id/edit' => 'translations#update',
    :as => :translations_edit

  devise_for :users, :path => "",
    :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout',
      :sign_up => '',
      :registration => 'register'
    }

  root :to => "translations#index"
end
