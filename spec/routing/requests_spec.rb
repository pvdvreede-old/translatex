require 'spec_helper'

describe 'routing to request' do
  it 'routes /request/pvdvreede/trans1 to the request controller with params' do
    expect(:post => "/request/pvdvreede/trans1").to route_to(
        :controller => "requests",
        :action => "index",
        :user => "pvdvreede",
        :translation => "trans1",
        :method => [:get, :post, :put, :delete]
      )

    expect(:get => "/request/pvdvreede/trans1").to route_to(
        :controller => "requests",
        :action => "index",
        :user => "pvdvreede",
        :translation => "trans1",
        :method => [:get, :post, :put, :delete]
      )

    expect(:put => "/request/pvdvreede/trans1").to route_to(
        :controller => "requests",
        :action => "index",
        :user => "pvdvreede",
        :translation => "trans1",
        :method => [:get, :post, :put, :delete]
      )

    expect(:delete => "/request/pvdvreede/trans1").to route_to(
        :controller => "requests",
        :action => "index",
        :user => "pvdvreede",
        :translation => "trans1",
        :method => [:get, :post, :put, :delete]
      )
  end
end