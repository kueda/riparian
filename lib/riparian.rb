module Riparian
  class Railtie < Rails::Railtie
    initializer 'riparian.initialize' do
      %w{ models views }.each do |dir|
        path = File.join(File.dirname(__FILE__), 'app', dir)
        $LOAD_PATH << path
        ActiveSupport::Dependencies.autoload_paths << path
      end
    end
  end
end
