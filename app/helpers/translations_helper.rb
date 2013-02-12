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
    "tx-icon-unlock-stroke"
  end

  def get_secure_description(tran)
    "This endpoint is accessible by anyone."
  end
end