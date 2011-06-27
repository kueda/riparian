require 'rails/generators'
require 'rails/generators/migration'

class RiparianGenerator < Rails::Generators::Base

  include Rails::Generators::Migration
  
  class_option "skip-controller", :type => :boolean, :desc => "Don't generate a controller for managing flow tasks."
  class_option "skip-views", :type => :boolean, :desc => "Don't create basic views for managing flow tasks."
  
  def self.source_root
     @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  # Implement the required interface for Rails::Generators::Migration.
  # Cribbed from DelayedJob
  def self.next_migration_number(dirname) #:nodoc:
    next_migration_number = current_migration_number(dirname) + 1
    if ActiveRecord::Base.timestamped_migrations
      [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
    else
      "%.3d" % next_migration_number
    end
  end
  
  def create_routes
    unless options["skip-controller"]
      route <<-EOT
  # Riparian routes
  resources :flow_tasks do
    member do
      get :run
    end
  end
      EOT
    end
  end
  
  def create_app_files
    unless options["skip-controller"]
      template 'flow_tasks_controller.rb', 'app/controllers/flow_tasks_controller.rb'
      unless options["skip-views"]
        template 'flow_tasks_helper.rb', 'app/helpers/flow_tasks_helper.rb'
        directory 'views/flow_tasks', 'app/views/flow_tasks'
      end
    end
  end
  
  def create_migration_file
    if defined?(ActiveRecord)
      migration_template 'migration.rb', 'db/migrate/create_riparian.rb'
    end
  end

end