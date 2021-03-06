require 'rails/generators/active_record'

class UnavailableDateGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('../../unavailability/unavailable_dates', __FILE__)

  desc 'Generate a migration file to create the `unavailable_dates` table'

  # https://github.com/norman/friendly_id/blob/master/lib/generators/friendly_id_generator.rb#L7
  argument :name, type: :string, default: 'random_name'

  def generate_migration
    migration_template 'migration.rb', 'db/migrate/create_unavailable_dates.rb'
  end
end
