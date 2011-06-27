ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'test/unit'
require 'rails/all'
require 'active_support/dependencies'
require 'riparian'

%w{ models views }.each do |dir|
  path = File.join(File.dirname(__FILE__), '../lib/app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
end

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
  ActiveRecord::Base.establish_connection(config['test'])
  load(File.dirname(__FILE__) + "/schema.rb")
end
