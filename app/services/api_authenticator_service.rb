# Service class to authenticate an api request based on
# the settings of the translation
class ApiAuthenticatorService

  def initialize(translation, controller)
    @translation = translation
    @controller = controller
    @authentication_type = get_authentication_type
  end

  def authenticate
    if @authentication_type.has_header?
      unless @authentication_type.authenticate
        @authentication_type.fail_authentication
      end
    else
      @authentication_type.fail_authentication
    end
  end

  private
  def get_authentication_type
    if @translation.all_authentication_active?
      return AllAuthenticator.new(@translation, @controller)
    end

    if @translation.api_key_enabled
      return ApiAuthenticator.new(@translation, @controller)
    end

    if @translation.basic_auth_enabled
      return BasicAuthenticator.new(@translation, @controller)
    end

    return NullAuthenticator.new(@translation, @controller)
  end
end

class BaseAuthenticator

  def initialize(translation, controller)
    @translation = translation
    @controller = controller
  end

  def has_header?
    raise "Not implemented"
  end

  def authenticate
    raise "Not implemented"
  end

  def fail_authentication
  end

  protected

  def has_basic_header?
    @controller.request.headers.has_key?("HTTP_AUTHORIZATION") &&
      @controller.request.headers["HTTP_AUTHORIZATION"] =~ /^Basic\s/
  end

  def has_api_header?
    @controller.request.headers.has_key?("HTTP_AUTHORIZATION") &&
      @controller.request.headers["HTTP_AUTHORIZATION"] =~ /^Token\s/
  end
end

class NullAuthenticator < BaseAuthenticator

  def has_header?
    true
  end

  def authenticate
    true
  end
end

class ApiAuthenticator < BaseAuthenticator

  def has_header?
    has_api_header?
  end

  def authenticate
    @controller.authenticate_or_request_with_http_token do |token, opt|
      @translation.api_key == token
    end
  end

  def fail_authentication
    @controller.request_http_token_authentication
  end
end

class BasicAuthenticator < BaseAuthenticator

  def has_header?
    has_basic_header?
  end

  def authenticate
    @controller.authenticate_with_http_basic do |user, pass|
      user == @translation.basic_auth_username &&
        pass == @translation.basic_auth_password
    end
  end

  def fail_authentication
    @controller.request_http_basic_authentication
  end
end

class AllAuthenticator < BaseAuthenticator

  def has_header?
    has_api_header? || has_basic_header?
  end

  def authenticate
    if has_api_header?
      @type = :api
      @controller.authenticate_or_request_with_http_token do |token, opt|
        @translation.api_key == token
      end
    elsif has_basic_header?
      @type = :basic
      @controller.authenticate_with_http_basic do |user, pass|
        user == @translation.basic_auth_username &&
          pass == @translation.basic_auth_password
      end
    end
  end

  def fail_authentication
    case @type
    when :basic
      @controller.request_http_basic_authentication
    when :api
      @controller.request_http_token_authentication
    end
  end
end