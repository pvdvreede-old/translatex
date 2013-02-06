require 'spec_helper'

describe 'routing to login' do
  it 'routes /login to the login page' do
    expect(:get => "/login").to route_to(
        :controller => "devise/sessions",
        :action => "new"
      )
  end

  it 'routes /logout to the logout controller' do
    expect(:delete => "/logout").to route_to(
        :controller => "devise/sessions",
        :action => "destroy"
      )
  end
end