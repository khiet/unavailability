module UnavailableDates
  class Remove
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
        # do nothing
      else
        overlappings.each do |unavailability|
          update(unavailability, from, to)
        end
      end

      user
    end

    private

    attr_reader :user, :from, :to

    def overlappings
      unavailable_dates.overlapping(from, to)
    end

    def update(unavailability, from, to)
      if from <= unavailability.from &&
        to >= unavailability.to

        unavailability.destroy
      else
        if from < unavailability.from
          unavailability.update(from: to + 1)
        elsif to > unavailability.to
          unavailability.update(to: from - 1)
        else # middle
          if from == unavailability.from
            if to < unavailability.to
              unavailability.update(from: to + 1)
            end
          elsif to == unavailability.to
            if from > unavailability.from
              unavailability.update(to: from - 1)
            end
          else
            to < unavailability.to
            split(unavailability, from, to)
          end
        end
      end
    end

    def split(unavailability, from, to)
      left_from = unavailability.from
      left_to = from - 1
      right_from = to + 1
      right_to = unavailability.to

      unavailability.destroy
      unavailable_dates.create(from: left_from, to: left_to)
      unavailable_dates.create(from: right_from, to: right_to)
    end
  end
end
