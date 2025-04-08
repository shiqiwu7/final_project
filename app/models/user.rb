class User < ApplicationRecord
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  # has_secure_password

  has_one :player, dependent: :destroy
  has_one :organizer, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[player organizer] }

  after_create :create_role_specific_record

  private

  # def create_role_specific_record
  #   if role == "player"
  #     # Ensure only one Player record is created per user
  #     Player.find_or_create_by(user: self)
  #   elsif role == "organizer"
  #     # Ensure only one Organizer record is created per user
  #     Organizer.find_or_create_by(user: self)
  #   end
  # end
  def create_role_specific_record
    if role == "player"
      player = Player.new(user: self, name: self.name)
      unless player.save
        Rails.logger.error("Failed to create player record for user #{id}: #{player.errors.full_messages.join(', ')}")
      end
    elsif role == "organizer"
      organizer = Organizer.new(user: self)
      unless organizer.save
        Rails.logger.error("Failed to create organizer record for user #{id}: #{organizer.errors.full_messages.join(', ')}")
      end
    end
  end
end
