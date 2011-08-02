require 'rubygems'
require 'paperclip'
require 'delayed_job'
require 'ostruct'

module Riparian
  DEFAULT_CONFIG = {
    :flow_task_resource_file_path => ":rails_root/public/system/:class/:id/:filename", 
    :flow_task_resource_file_url => "/system/:class/:id/:filename"
  }
  
  def self.config
    @config ||= OpenStruct.new(DEFAULT_CONFIG)
  end
  
  def self.config=(new_config)
    @config = new_config
  end
  
  class Railtie < Rails::Railtie
    config.before_configuration do
      path = ::Rails.root.join('config/riparian.yml')
      if ::Rails.root.join('config/riparian.yml').exist?
        Riparian.config = OpenStruct.new(YAML.load(open(path)).symbolize_keys)
      end
    end
    
    initializer 'riparian.initialize' do
      # Load models
      %w{ models }.each do |dir|
        path = File.join(File.dirname(__FILE__), 'app', dir)
        $LOAD_PATH << path
        ActiveSupport::Dependencies.autoload_paths << path
      end
    end
  end
end
