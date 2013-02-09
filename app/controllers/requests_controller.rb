# controller that contains the main endpoint for all api requests
# the user is checked and translation is obtained
class RequestsController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :get_user, :get_translation

  def index
    post_body = request.body.read
    xslt = @translation.xslt
    transformer = Translatex::Transformer.new(post_body, xslt)
    response_xml = transformer.transform
    render :status => 200, :text => response_xml.to_s
  end

  private

  def get_user
    @user = User.where(
      :identifier => params[:user]
    ).first

    if @user.nil?
      not_found
    end
  end

  def get_translation
    @translation = @user.translations.where(
      :identifier => params[:translation],
      :active => true
    ).first

    if @translation.nil?
      not_found
    end
  end

end