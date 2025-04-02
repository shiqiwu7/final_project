class Event < ApplicationRecord
  belongs_to :organizer

  has_many :participations, dependent: :destroy
  has_many :teams, through: :participations
  has_one :result, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :location, presence: true

  validate :end_date_after_start_date

  scope :upcoming, -> { where("end_date >= ?", Date.today).order(:start_date) }
  scope :past, -> { where("end_date < ?", Date.today).order(start_date: :desc) }

  def end_date_after_start_date
    if start_date && end_date && end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
