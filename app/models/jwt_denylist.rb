# class JwtDenylist < ApplicationRecord
#   belongs_to :user

#   validates :jti, presence: true, uniqueness: true

#   include Devise::JWT::RevocationStrategies::Denylist
# end
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = 'jwt_denylists'
end