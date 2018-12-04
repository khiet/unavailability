require "unavailability/version"

require 'active_record'

module Unavailability
  def self.included(base)
    base.class_eval do
      has_many :unavailable_dates, as: :datable, dependent: :destroy

      scope :available_for_date, ->(date) do
        where("NOT EXISTS (SELECT unavailable_dates.* FROM unavailable_dates WHERE unavailable_dates.datable_type = '#{base.to_s}' AND unavailable_dates.datable_id = #{base.table_name}s.id AND (unavailable_dates.from <= ? AND unavailable_dates.to >= ?))", date, date)
      end
    end
  end

  def available_for_date?(date)
    unavailable_dates.each do |unavailable_date|
      return false if unavailable_date.range.cover?(date)
    end

    true
  end
end
