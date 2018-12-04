require "unavailability/version"

module Unavailability
  def self.included(base)
    base.class_eval do
      has_many :unavailable_dates, dependent: :destroy
    end

    scope :available_for_date, ->(date) do
      where('NOT EXISTS (SELECT unavailable_dates.* FROM unavailable_dates WHERE unavailable_dates.user_id = users.id AND (unavailable_dates.from <= ? AND unavailable_dates.to >= ?))', date, date)
    end
  end

  def available_for_date?(date)
    unavailable_dates.each do |unavailable_date|
      return false if unavailable_date.range.cover?(date)
    end

    true
  end
end
