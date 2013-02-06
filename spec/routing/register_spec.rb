require 'spec_helper'

describe 'routing to registration' do
  it 'routes /register to the registration page' do
    expect(:get => "/register").to route_to(
        :controller => "devise/registrations",
        :action => "new"
      )
  end
end