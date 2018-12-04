require 'rails/generators'
require 'rails/generators/active_record'

class UnavailableDateGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('../unavailable_date', __FILE__)

  def generate_migration
    migration_template 'migration.rb', 'db/migrate/create_unavailable_dates.rb'
  end
end
