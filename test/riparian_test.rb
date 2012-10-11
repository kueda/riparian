require 'test_helper'

class RiparianTest < ActiveSupport::TestCase
  load_schema
  
  def test_riparian_configurable
    assert !Riparian.config.nil?
    assert !Riparian.config.flow_task_resource_file_path.nil?
  end
end
