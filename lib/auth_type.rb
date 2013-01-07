class AuthType < Settingslogic
  source "#{Rails.root}/config/auth_types.yml"
  namespace Rails.env
end
