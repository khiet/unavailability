module Unavailability
  class UnavailableDate < ActiveRecord::Base
    belongs_to :datable, polymorphic: true

    validates :from, :to, :datable, presence: true
    # validates :datable, uniqueness: { scope: [:from, :to] }

    scope :overlapping, ->(from, to) do
      where("'unavailable_dates'.'from' <= ? AND 'unavailable_dates'.'to' >= ?", to, from)
    end

    scope :overlapping_including_nabour, ->(from, to) do
      overlapping(from.to_date - 1, to.to_date + 1)
    end

    def range
      (from .. to)
    end
  end
end
