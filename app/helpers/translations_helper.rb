module TranslationsHelper
  def get_active_icon(tran)
    if tran.active
      "tx-icon-checkmark"
    else
      "tx-icon-x"
    end
  end

  def get_active_description(tran)
    prefix = "This endpoint is "
    if tran.active
      prefix += "active"
    else
      prefix += "disabled"
    end
    prefix
  end

  def get_secure_icon(tran)
    if tran.api_key_enabled || tran.basic_auth_enabled
      "tx-icon-lock-stroke"
    else
      "tx-icon-unlock-stroke"
    end
  end

  def get_secure_description(tran)
    if tran.api_key_enabled && tran.basic_auth_enabled
      "This endpoint is restricted by api key and basic authentication"
    elsif tran.api_key_enabled
      "This endpoint is restricted by api key"
    elsif tran.basic_auth_enabled
      "This endpoint is restricted by basic authentication"
    else
      "This endpoint is accessible by anyone"
    end
  end
end