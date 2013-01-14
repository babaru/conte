require 'sina_weibo/exceptions'

module SinaWeibo
  class ApiWrapper
    attr_reader :access_token
    attr_reader :request_data
    
    def initialize(token)
      @access_token = token
    end
    
    def status_update(content)
      post_request(SinaWeiboApiSettings.api.status.update, :status => content)
    end
    
    def status_upload(content, image_path)
      post_request(SinaWeiboApiSettings.api.status.upload, :status => content, :pic => File.new(image_path, 'rb'))
    end
    
    def status_user_timeline(uid, page = 1, count = 100)
      get_request(SinaWeiboApiSettings.api.status.user_timeline, :params => {:uid => uid, :page => page, :count => count})
    end
    
    def status_repost_timeline(post_id, page = 1)
      get_request(SinaWeiboApiSettings.api.status.repost_timeline, :params => {:id => post_id, :page => page, :count => 50})
    end

    def comments_show(post_id, page = 1)
      get_request(SinaWeiboApiSettings.api.comments.show, :params => {:id => post_id, :page => page, :count => 50})
    end
    
    def status_show(wb_post_id)
      get_request(SinaWeiboApiSettings.api.status.show, :params => {:id => wb_post_id})
    end
    
    def user_show(uid, is_number_id = true)
      if is_number_id
        get_request(SinaWeiboApiSettings.api.user.show, {:params => {:uid => uid}})
      else
        get_request(SinaWeiboApiSettings.api.user.show, {:params => {:screen_name => uid}})
      end
    end

    def user_domain_show(domain)
      get_request(SinaWeiboApiSettings.api.user.domain_show, :params => {:domain => domain})
    end

    def friendships_followers(uid, cursor)
      get_request(SinaWeiboApiSettings.api.friendships.followers, :params => {:uid => uid, :cursor => cursor})
    end

    def friendships_followers_ids(uid, cursor)
      get_request(SinaWeiboApiSettings.api.friendships.followers_ids, :params => {:uid => uid, :cursor => cursor})
    end
    
    def tags(uid)
      get_request(SinaWeiboApiSettings.api.tags, :params => {:uid => uid})
    end
    
    def queryid(mid)
      data = get_request(SinaWeiboApiSettings.api.status.queryid, {:params => {:mid => mid, :type => 1, :isBase62 => 1}})
    end

    def querymid(id, batch = false)
      data = get_request(SinaWeiboApiSettings.api.status.querymid, {:params => {:id => id, :type => 1, :is_batch => batch ? 1 : 0}})
    end

    def querymids(ids)
      ids_str = ids.join(',')
      querymid(ids_str, true)
    end
    
    private
    
    def post_request(url, data)
      rest_request(url, data, true)
    end
    
    def get_request(url, data)
      r = rest_request(url, data, false)
      return r
    end

    def rest_request(url, data, method_post)
      result, code = do_request url, data, method_post

      while code == -1
        change_access_token
        result, code = do_request url, data, method_post
      end

      return result
    end
    
    def do_request(url, data, method_post)
      if method_post
        rd  = data.clone
        rd[:access_token] = @access_token
        r = JSON.parse RestClient.post(url, rd)
        Rails.logger.debug "- Request response: #{r}"
        return r
      else
        rd  = data.clone
        params = {:access_token => @access_token}
        rd[:params] = data[:params].merge(params)
        Rails.logger.debug "Request params hash is #{rd}"

        r = JSON.parse RestClient.get(url, rd)
        Rails.logger.debug "- Request response: #{r}"
        return r
      end
    rescue RestClient::Exception => e
      Rails.logger.error "! Request Failed #{e.to_s}"
      r = JSON.parse e.http_body
      Rails.logger.error "! Sina Weibo API Error Code: #{r["error_code"]} Error: #{r["error"]}"
      api_error_code = r["error_code"].to_i

      if invalid_access_token?(api_error_code) || reached_account_access_limit?(api_error_code)
        ex = SinaWeibo::InvalidAccessTokenException.new(self.access_token)
        raise ex
      elsif reached_ip_access_limit? api_error_code
        ex = SinaWeibo::IPAccessLimitException.new
        raise ex
      else
        ex = SinaWeibo::ApiException.new e
        raise ex
      end
    end

    def invalid_access_token?(error_code)
      return error_code == 21332 || error_code == 21327
    end

    def reached_account_access_limit?(error_code)
      return error_code == 10023 || error_code == 10024
    end

    def reached_ip_access_limit?(error_code)
      return error_code == 10022
    end
  end
end