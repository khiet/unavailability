require "unavailability/version"

require 'active_record'

require 'unavailability/unavailable_date'
require 'unavailability/unavailable_dates/add'
require 'unavailability/unavailable_dates/remove'

module Unavailability
  def self.included(base)
    base.class_eval do
      has_many :unavailable_dates, as: :dateable, dependent: :destroy, class_name: 'Unavailability::UnavailableDate'

      scope :available_for_date, ->(date) do
        user_table  = arel_table
        u_table     = Unavailability::UnavailableDate.arel_table
        u_condition = u_table[:dateable_id].eq(user_table[:id]).and(u_table[:from].lteq(date)).and(u_table[:to].gteq(date))

        where(Unavailability::UnavailableDate.where(u_condition).arel.exists.not)
      end
    end
  end

  def available_for_date?(date)
    unavailable_dates.each do |unavailable_date|
      return false if (unavailable_date.from..unavailable_date.to).cover?(date)
    end

    true
  end

  def make_unavailable(from:, to:)
    Unavailability::UnavailableDates::Add.new(self, from, to).call
  end

  def make_available(from:, to:)
    Unavailability::UnavailableDates::Remove.new(self, from, to).call
  end
end
