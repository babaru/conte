class Account < ActiveRecord::Base
  belongs_to :planet
  attr_accessible :access_token, :expires_at, :is_expired, :name, :planet_uid, :planet_id
end
