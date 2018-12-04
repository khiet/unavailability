module Unavailability
  class UnavailableDate < ActiveRecord::Base
    belongs_to :datable, polymorphic: true
  end
end
