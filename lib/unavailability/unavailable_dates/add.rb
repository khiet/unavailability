module Unavailability
  module UnavailableDates
    class Add
      def initialize(user, from, to)
        @user = user
        @from = from
        @to = to
      end

      def unavailable_dates
        user.unavailable_dates
      end

      def call
        if overlappings.empty?
          unavailable_dates.create(
            from: from,
            to: to
          )
        else
          overlappings.each do |unavailability|
            update(unavailability, from, to)
          end

          merge(overlappings)
        end

        user
      end

      private

      attr_reader :user, :from, :to

      def overlappings
        unavailable_dates.overlapping_including_nabour(from, to)
      end

      def update(unavailability, from, to)
        if from < unavailability.from
          if to > unavailability.to
            unavailability.update(from: from)
            unavailability.update(to: to)
          else
            unavailability.update(from: from)
          end
        elsif to > unavailability.to
          unavailability.update(to: to)
        end
      end

      def merge(overlappings)
        from = overlappings.map(&:from).min
        to = overlappings.map(&:to).max
        overlappings.each(&:destroy)
        unavailable_dates.create(from: from, to: to)
      end
    end
  end
end
