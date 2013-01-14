module SinaWeibo
  class Exception < RuntimeError
    attr_accessor :message

    def initialize message = nil
      @message = message
    end

    def inspect
      self.message
    end

    def to_s
      inspect
    end
  end

  class IPAccessLimitException < Exception
    def initialize
      super "Reached IP access limit"
    end
  end

  class NoAccessTokenAvaiableException < Exception
    def initialize
      super "There is no valid access token available"
    end 
  end

  class InvalidAccessTokenException < Exception
    def initialize(token)
      super "The access token: #{token} is not valid"
    end 
  end

  class ApiException < Exception
    def initialize(exception)
      response = JSON.parse exception.http_body
      super "#{exception.to_s}: [#{response['error_code']}] #{response['error']}"
    end
  end
end