module Unavailability
  class UnavailableDate < ActiveRecord::Base
    belongs_to :dateable, polymorphic: true

    validates :from, :to, :dateable, presence: true

    scope :overlapping, ->(from, to) do
      where(from_overlapped_by(to: to)).where(to_overlapped_by(from: from))
    end

    scope :overlapping_including_nabour, ->(from, to) do
      overlapping(from.to_date - 1, to.to_date + 1)
    end

    class << self
      def to_overlapped_by(from:)
        table[:to].gteq(from)
      end

      def from_overlapped_by(to:)
        table[:from].lteq(to)
      end

      def table
        Unavailability::UnavailableDate.arel_table
      end
    end
  end
end
