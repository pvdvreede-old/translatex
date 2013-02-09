require 'spec_helper'

describe 'routing to request' do
  it 'routes /request/pvdvreede/trans1 to the request controller with params' do
    expect(:post => "/request/pvdvreede/trans1").to route_to(
        :controller => "requests",
        :action => "index",
        :user => "pvdvreede",
        :translation => "trans1"
      )
  end
end