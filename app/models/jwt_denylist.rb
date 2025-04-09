class JwtDenylist < ApplicationRecord
  belongs_to :user

  validates :jti, presence: true, uniqueness: true

  include Devise::JWT::RevocationStrategies::Denylist
end
