class SinaWeiboApiSettings < ::Settingslogic
  source "#{Rails.root}/config/sina_weibo_api_settings.yml"
  namespace Rails.env
end