Translatex::Application.routes.draw do
  devise_for :users, :path => "",
    :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout',
      :sign_up => '',
      :registration => 'register'
    }

  root :to => "home#index"
end
