require 'test_helper'

class RiparianTest < ActiveSupport::TestCase
  load_schema
  
  class FlowTask < ActiveRecord::Base
  end
  
  def test_schema_has_loaded_correctly
    assert_equal [], FlowTask.all
  end
end
